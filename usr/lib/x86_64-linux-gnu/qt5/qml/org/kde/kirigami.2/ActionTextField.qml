/*
 *  SPDX-FileCopyrightText: 2019 Carl-Lucien Schwan <carl@carlschwan.eu>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.6
import QtQuick.Controls 2.1 as Controls
import org.kde.kirigami 2.7 as Kirigami

/**
 * This is advanced textfield. It is recommended to use this class when there
 * is a need to create a create a textfield with action buttons(e.g a clear
 * action).
 *
 * Example usage for a search field:
 * @code
 * import org.kde.kirigami 2.7 as Kirigami
 *
 * Kirigami.ActionTextField {
 *     id: searchField
 *
 *     placeholderText: i18n("Search...")
 *
 *     focusSequence: "Ctrl+F"
 *
 *     rightActions: [
 *         Kirigami.Action {
 *             icon.name: "edit-clear"
 *             visible: searchField.text !== ""
 *             onTriggered: {
 *                 searchField.text = ""
 *                 searchField.accepted()
 *             }
 *         }
 *     ]
 *
 *     onAccepted: console.log("Search text is " + searchField.text)
 * }
 * @endcode
 *
 * @inherit QtQuick.Controls.TextField
 */
Controls.TextField
{
    id: root

    /**
     * This property holds a shortcut sequence that will focus the text field.
     */
    property string focusSequence

    /**
     * This property holds a list of actions that will be displayed on the left side of the text field.
     *
     * By default this list is empty.
     */
    property list<QtObject> leftActions

    /**
     * This property holds a list of actions that will be displayed on the right side of the text field.
     *
     * By default this list is empty.
     */
    property list<QtObject> rightActions

    property alias _leftActionsRow: leftActionsRow
    property alias _rightActionsRow: rightActionsRow

    hoverEnabled: true

    leftPadding: if (Qt.application.layoutDirection === Qt.RightToLeft) {
        return _rightActionsRow.width + Kirigami.Units.smallSpacing
    } else {
        return _leftActionsRow.width + Kirigami.Units.smallSpacing
    }
    rightPadding: if (Qt.application.layoutDirection === Qt.RightToLeft) {
        return _leftActionsRow.width + Kirigami.Units.smallSpacing
    } else {
        return _rightActionsRow.width + Kirigami.Units.smallSpacing
    }

    Behavior on leftPadding {
        NumberAnimation {
            duration: Kirigami.Units.longDuration
            easing.type: Easing.InOutQuad
        }
    }

    Behavior on rightPadding {
        NumberAnimation {
            duration: Kirigami.Units.longDuration
            easing.type: Easing.InOutQuad
        }
    }


    Shortcut {
        id: focusShortcut
        enabled: root.focusSequence
        sequence: root.focusSequence
        onActivated: {
            root.forceActiveFocus()
            root.selectAll()
        }
    }

    Controls.ToolTip {
        visible: root.focusSequence && root.text.length === 0 && !rightActionsRow.hovered && !leftActionsRow.hovered && hovered
        text: root.focusSequence ? root.focusSequence : ""
    }

    Row {
        id: leftActionsRow
        padding: Kirigami.Units.smallSpacing
        anchors.left: parent.left
        anchors.leftMargin: Kirigami.Units.smallSpacing
        anchors.top: parent.top
        anchors.topMargin: parent.topPadding
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.bottomPadding
        Repeater {
            model: root.leftActions
            Kirigami.Icon {
                implicitWidth: Kirigami.Units.iconSizes.sizeForLabels
                implicitHeight: Kirigami.Units.iconSizes.sizeForLabels

                anchors.verticalCenter: parent.verticalCenter
                anchors.bottomMargin: root.bottomPadding
                anchors.bottom: parent.bottom

                source: modelData.icon.name.length > 0 ? modelData.icon.name : modelData.icon.source
                visible: modelData.visible
                enabled: modelData.enabled
                MouseArea {
                    anchors.fill: parent
                    onClicked: modelData.trigger()
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
    }

    Row {
        id: rightActionsRow
        padding: Kirigami.Units.smallSpacing
        layoutDirection: Qt.RightToLeft
        anchors.right: parent.right
        anchors.rightMargin: Kirigami.Units.smallSpacing
        anchors.top: parent.top
        anchors.topMargin: parent.topPadding
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.bottomPadding
        Repeater {
            model: root.rightActions
            Kirigami.Icon {
                implicitWidth: Kirigami.Units.iconSizes.sizeForLabels
                implicitHeight: Kirigami.Units.iconSizes.sizeForLabels

                anchors.verticalCenter: parent.verticalCenter

                source: modelData.icon.name.length > 0 ? modelData.icon.name : modelData.icon.source
                active: actionArea.containsPress
                visible: modelData.visible
                enabled: modelData.enabled
                MouseArea {
                    id: actionArea
                    anchors.fill: parent
                    onClicked: modelData.trigger()
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
    }
}
