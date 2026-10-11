import logging

from ollama import chat
from backend import database


logger = logging.getLogger(__name__)


class DistractionClassifier:
    def __init__(self):
        # Dict of websites, apps, and keywords that are given by the user beforehand
        self.websites = {}
        self.apps = {}
        self.keywords = {}
        self.answer_cache = {}

    def classify_website(self, website, title, goal):
        if website in self.websites:
            return self.websites[website]

        return self.classify_with_model('website', website, title, goal)

    def classify_app(self, app, title, goal):
        if app in self.apps:
            return self.apps[app]

        return self.classify_with_model('app', app, title, goal)

    def classify_keyword(self, name, title, goal, keyword):
        if keyword in self.keywords:
            return self.keywords[keyword]

        return 'S'

    def add_website(self, website, distraction_level):
        # D is distracted, A is ask, and S is Safe
        if distraction_level == 1:
            self.websites[website] = 'D'
        elif distraction_level == 0:
            self.websites[website] = 'A'
        elif distraction_level == -1:
            self.websites[website] = 'S'

    def add_app(self, app, distraction_level):
        # D is distracted, A is ask, and S is Safe
        if distraction_level == 1:
            self.apps[app] = 'D'
        elif distraction_level == 0:
            self.apps[app] = 'A'
        elif distraction_level == -1:
            self.apps[app] = 'S'

    def classify_with_model(self, activity_type, name, title, goal):
        cache_result = self.get_answer_cache(activity_type, name, title, goal)

        if cache_result != '':
            return cache_result

        prompt = f"""
        You classify computer activity during a study session.

        Labels:

        S = SAFE
        The activity clearly and directly helps the user complete the study goal.

        D = DISTRACTING
        The activity is clearly unrelated entertainment, gaming, shopping,
        social media browsing, or other clearly distracting content.

        A = ASK
        There is not enough information to decide.
        The activity could reasonably be useful or distracting.
        Generic apps and unclear titles should be A.

        Important rules:

        1. Do not classify based on one matching word.
        2. Do not return D just because the activity is not obviously safe.
        3. Return D only when it is clearly distracting.
        4. Return S only when it is clearly related to the goal.
        5. Return A when evidence is missing or uncertain.
        6. Generic titles such as ChatGPT, Discord, YouTube, Chrome, or Calculator are A.
        7. Study music and focus playlists are S because they may help some users.
        8. Tutorials, explanations, assignments, documentation, and drafts that
           directly match the study goal are S.
        9. The activity type tells you if it is an app or a website.

        Examples:

        Goal: Study Python programming
        Title: Python Tutorial for Beginners
        Answer: S

        Goal: Study Python programming
        Title: Python Snake Attacks Zookeeper
        Answer: D

        Goal: Complete chemistry homework
        Title: Explanation of Intermolecular Forces
        Answer: S

        Goal: Study gravity
        Title: Defying Gravity Song Lyrics
        Answer: D

        Goal: Complete physics homework
        Title: ChatGPT
        Answer: A

        Goal: Complete math homework
        Title: Study Music for Concentration
        Answer: A

        Goal: Study physics
        Title: Discord
        Answer: A

        Now classify this activity:

        Study goal:
        {goal}

        App or website:
        {name}

        Window title:
        {title}

        Activity type:
        {activity_type}

        Return exactly one letter: S, D, or A.
        """

        try:
            response = chat(
                model="qwen3.5:2b",
                messages=[{"role": "user", "content": prompt}],
                options={"temperature": 0, "num_predict": 20},
                think=False
            )

            result = response.message.content.strip().upper()

            if result in ['D', 'A', 'S']:
                self.update_answer_cache(activity_type, name, title, goal, result)
                return result

            return 'A'

        except Exception as error:
            logger.warning("Could not classify activity with Ollama: %s", error)
            return 'A'

    def update_answer_cache(self, activity_type, name, title, goal, classification):
        database.create_database()
        database.update_activity_answer(activity_type, name, title, goal, classification)

    def clear_answer_cache(self):
        database.clear_activity_cache()

    def get_answer_cache(self, activity_type, name, title, goal):
        cache_result = database.get_activity_answer(activity_type, name, title, goal)

        if cache_result is not None:
            return cache_result

        return ''