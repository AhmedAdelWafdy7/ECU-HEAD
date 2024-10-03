QT += quick qml core 3dinput
QT += 3dcore 3drender 3dquick 3dquick-private

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        main.cpp \
        scenehelper.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    icons/Road/Frame 33.png \
    icons/Road/SpeedLimit.svg \
    icons/Road/car.png \
    icons/Road/carRoad.svg \
    icons/Road/mdi_clock-time-four-outline.svg \
    icons/Road/mdi_map-marker-outline.svg \
    icons/Road/mdi_turn-right-bold.svg \
    icons/Road/mingcute_steering-wheel-fill.svg \
    icons/Road/road.png \
    icons/Road/road2.png \
    icons/Road/road3.svg \
    icons/Road/ss.svg \
    icons/Vector 1.png \
    icons/Vector 1.svg \
    icons/Vector 2.png \
    icons/Vector 2.svg \
    icons/bottom.png \
    icons/cloud.svg \
    icons/desal.svg \
    icons/feaul.svg \
    icons/icons-left-checked/icon-park-solid_right-two.svg \
    icons/icons-left-checked/mdi_car-battery.svg \
    icons/icons-left-checked/mdi_car-handbrake.svg \
    icons/icons-left-checked/mdi_car-tire-alert.svg \
    icons/icons-left-checked/mdi_oil.svg \
    icons/icons-left-checked/ph_engine-bold.svg \
    icons/icons-left/icon-park-solid_right-two.svg \
    icons/icons-left/mdi_car-battery.svg \
    icons/icons-left/mdi_car-handbrake.svg \
    icons/icons-left/mdi_car-tire-alert.svg \
    icons/icons-left/mdi_oil.svg \
    icons/icons-left/ph_engine-bold.svg \
    icons/icons-right-checked/icon-park-solid_right-two.svg \
    icons/icons-right-checked/mdi_car-brake-parking.svg \
    icons/icons-right-checked/mdi_car-light-dimmed.svg \
    icons/icons-right-checked/mdi_car-light-fog.svg \
    icons/icons-right-checked/mdi_car-light-high.svg \
    icons/icons-right-checked/mdi_seatbelt.svg \
    icons/icons-right/icon-park-solid_right-two.svg \
    icons/icons-right/mdi_car-brake-parking.svg \
    icons/icons-right/mdi_car-light-dimmed.svg \
    icons/icons-right/mdi_car-light-fog.svg \
    icons/icons-right/mdi_car-light-high.svg \
    icons/icons-right/mdi_seatbelt.svg \
    icons/left.svg


# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /home/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    scenehelper.h
