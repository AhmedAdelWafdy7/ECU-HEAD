cmake_minimum_required(VERSION 3.15)
project(ECU-HeadUnit)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt5 COMPONENTS Core Quick SerialBus Gui REQUIRED)

add_executable(HeadUUnit
        src/HeadUnit.cpp
        src/HeadUnitQtClass.cpp
        src/qml.qrc
)

target_compile_definitions(HeadUnit
PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(HeadUnit
PRIVATE Qt5::Core Qt5::Quick Qt5::SerialBus Qt5::Gui)

install(TARGETS HeadUnit DESTINATION /usr/bin/)
