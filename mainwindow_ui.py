# -*- coding: utf-8 -*-

################################################################################
## Form generated from reading UI file 'interface.ui'
##
## Created by: Qt User Interface Compiler version 6.11.1
##
## WARNING! All changes made in this file will be lost when recompiling UI file!
################################################################################

from PySide6.QtCore import (QCoreApplication, QDate, QDateTime, QLocale,
    QMetaObject, QObject, QPoint, QRect,
    QSize, QTime, QUrl, Qt)
from PySide6.QtGui import (QBrush, QColor, QConicalGradient, QCursor,
    QFont, QFontDatabase, QGradient, QIcon,
    QImage, QKeySequence, QLinearGradient, QPainter,
    QPalette, QPixmap, QRadialGradient, QTransform)
from PySide6.QtWidgets import (QApplication, QFrame, QHBoxLayout, QLabel,
    QLayout, QMainWindow, QMenuBar, QPushButton,
    QSizePolicy, QSpacerItem, QStatusBar, QVBoxLayout,
    QWidget)

class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        if not MainWindow.objectName():
            MainWindow.setObjectName(u"MainWindow")
        MainWindow.resize(1090, 752)
        sizePolicy = QSizePolicy(QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Expanding)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(MainWindow.sizePolicy().hasHeightForWidth())
        MainWindow.setSizePolicy(sizePolicy)
        self.centralwidget = QWidget(MainWindow)
        self.centralwidget.setObjectName(u"centralwidget")
        sizePolicy.setHeightForWidth(self.centralwidget.sizePolicy().hasHeightForWidth())
        self.centralwidget.setSizePolicy(sizePolicy)
        self.verticalLayout_2 = QVBoxLayout(self.centralwidget)
        self.verticalLayout_2.setObjectName(u"verticalLayout_2")
        self.verticalLayout = QVBoxLayout()
        self.verticalLayout.setSpacing(10)
        self.verticalLayout.setObjectName(u"verticalLayout")
        self.verticalLayout.setSizeConstraint(QLayout.SizeConstraint.SetDefaultConstraint)
        self.verticalLayout.setContentsMargins(20, 20, 20, 20)
        self.time_label = QLabel(self.centralwidget)
        self.time_label.setObjectName(u"time_label")
        sizePolicy1 = QSizePolicy(QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Preferred)
        sizePolicy1.setHorizontalStretch(0)
        sizePolicy1.setVerticalStretch(0)
        sizePolicy1.setHeightForWidth(self.time_label.sizePolicy().hasHeightForWidth())
        self.time_label.setSizePolicy(sizePolicy1)
        font = QFont()
        font.setPointSize(20)
        font.setBold(True)
        self.time_label.setFont(font)
        self.time_label.setAlignment(Qt.AlignmentFlag.AlignCenter)

        self.verticalLayout.addWidget(self.time_label)

        self.status_label = QLabel(self.centralwidget)
        self.status_label.setObjectName(u"status_label")
        sizePolicy1.setHeightForWidth(self.status_label.sizePolicy().hasHeightForWidth())
        self.status_label.setSizePolicy(sizePolicy1)
        font1 = QFont()
        font1.setPointSize(14)
        font1.setBold(True)
        self.status_label.setFont(font1)
        self.status_label.setAlignment(Qt.AlignmentFlag.AlignCenter)

        self.verticalLayout.addWidget(self.status_label)

        self.camera_label = QLabel(self.centralwidget)
        self.camera_label.setObjectName(u"camera_label")
        sizePolicy.setHeightForWidth(self.camera_label.sizePolicy().hasHeightForWidth())
        self.camera_label.setSizePolicy(sizePolicy)
        self.camera_label.setMinimumSize(QSize(640, 480))
        self.camera_label.setFrameShape(QFrame.Shape.Box)
        self.camera_label.setAlignment(Qt.AlignmentFlag.AlignCenter)

        self.verticalLayout.addWidget(self.camera_label)

        self.horizontalLayout = QHBoxLayout()
        self.horizontalLayout.setSpacing(10)
        self.horizontalLayout.setObjectName(u"horizontalLayout")
        self.horizontalSpacer = QSpacerItem(16, 20, QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Minimum)

        self.horizontalLayout.addItem(self.horizontalSpacer)

        self.start_button = QPushButton(self.centralwidget)
        self.start_button.setObjectName(u"start_button")
        sizePolicy2 = QSizePolicy(QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Fixed)
        sizePolicy2.setHorizontalStretch(0)
        sizePolicy2.setVerticalStretch(0)
        sizePolicy2.setHeightForWidth(self.start_button.sizePolicy().hasHeightForWidth())
        self.start_button.setSizePolicy(sizePolicy2)

        self.horizontalLayout.addWidget(self.start_button)

        self.pause_button = QPushButton(self.centralwidget)
        self.pause_button.setObjectName(u"pause_button")
        sizePolicy2.setHeightForWidth(self.pause_button.sizePolicy().hasHeightForWidth())
        self.pause_button.setSizePolicy(sizePolicy2)

        self.horizontalLayout.addWidget(self.pause_button)

        self.reset_button = QPushButton(self.centralwidget)
        self.reset_button.setObjectName(u"reset_button")
        sizePolicy2.setHeightForWidth(self.reset_button.sizePolicy().hasHeightForWidth())
        self.reset_button.setSizePolicy(sizePolicy2)

        self.horizontalLayout.addWidget(self.reset_button)

        self.quit_button = QPushButton(self.centralwidget)
        self.quit_button.setObjectName(u"quit_button")
        sizePolicy2.setHeightForWidth(self.quit_button.sizePolicy().hasHeightForWidth())
        self.quit_button.setSizePolicy(sizePolicy2)

        self.horizontalLayout.addWidget(self.quit_button)

        self.horizontalSpacer_2 = QSpacerItem(16, 10, QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Minimum)

        self.horizontalLayout.addItem(self.horizontalSpacer_2)


        self.verticalLayout.addLayout(self.horizontalLayout)

        self.verticalLayout.setStretch(2, 1)

        self.verticalLayout_2.addLayout(self.verticalLayout)

        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QMenuBar(MainWindow)
        self.menubar.setObjectName(u"menubar")
        self.menubar.setGeometry(QRect(0, 0, 1090, 33))
        MainWindow.setMenuBar(self.menubar)
        self.statusbar = QStatusBar(MainWindow)
        self.statusbar.setObjectName(u"statusbar")
        MainWindow.setStatusBar(self.statusbar)

        self.retranslateUi(MainWindow)

        QMetaObject.connectSlotsByName(MainWindow)
    # setupUi

    def retranslateUi(self, MainWindow):
        MainWindow.setWindowTitle(QCoreApplication.translate("MainWindow", u"Focus Detector", None))
        self.time_label.setText(QCoreApplication.translate("MainWindow", u"Focus Time: 00:00:00", None))
        self.status_label.setText(QCoreApplication.translate("MainWindow", u"Status: Starting", None))
        self.camera_label.setText(QCoreApplication.translate("MainWindow", u"Starting webcam...", None))
        self.start_button.setText(QCoreApplication.translate("MainWindow", u"Start", None))
        self.pause_button.setText(QCoreApplication.translate("MainWindow", u"Pause", None))
        self.reset_button.setText(QCoreApplication.translate("MainWindow", u"Reset", None))
        self.quit_button.setText(QCoreApplication.translate("MainWindow", u"Quit", None))
    # retranslateUi

