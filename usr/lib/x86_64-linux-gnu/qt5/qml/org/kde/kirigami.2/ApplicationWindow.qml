/*
 *  SPDX-FileCopyrightText: 2015 Marco Martin <mart@kde.org>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.5
import "templates/private"
import org.kde.kirigami 2.4 as Kirigami

/**
 * A window that provides some basic features needed for all apps
 *
 * It's usually used as a root QML component for the application.
 * It's based around the PageRow component, the application will be
 * about pages adding and removal.
 * For most of the usages, this class should be used instead
 * of AbstractApplicationWindow
 * @see AbstractApplicationWindow
 *
 * Setting a width and height property on the ApplicationWindow
 * will set its initial size, but it won't set it as an automatically binding.
 * to resize programmatically the ApplicationWindow they need to
 * be assigned again in an imperative fashion
 * 
 * Example usage:
 * @code
 * import org.kde.kirigami 2.4 as Kirigami
 *
 * Kirigami.ApplicationWindow {
 *  [...]
 *     globalDrawer: Kirigami.GlobalDrawer {
 *         actions: [
 *            Kirigami.Action {
 *                text: "View"
 *                iconName: "view-list-icons"
 *                Kirigami.Action {
 *                        text: "action 1"
 *                }
 *                Kirigami.Action {
 *                        text: "action 2"
 *                }
 *                Kirigami.Action {
 *                        text: "action 3"
 *                }
 *            },
 *            Kirigami.Action {
 *                text: "Sync"
 *                iconName: "folder-sync"
 *            }
 *         ]
 *     }
 *
 *     contextDrawer: Kirigami.ContextDrawer {
 *         id: contextDrawer
 *     }
 *
 *     pageStack.initialPage: Kirigami.Page {
 *         mainAction: Kirigami.Action {
 *             iconName: "edit"
 *             onTriggered: {
 *                 // do stuff
 *             }
 *         }
 *         contextualActions: [
 *             Kirigami.Action {
 *                 iconName: "edit"
 *                 text: "Action text"
 *                 onTriggered: {
 *                     // do stuff
 *                 }
 *             },
 *             Kirigami.Action {
 *                 iconName: "edit"
 *                 text: "Action text"
 *                 onTriggered: {
 *                     // do stuff
 *                 }
 *             }
 *         ]
 *       [...]
 *     }
 *  [...]
 * }
 * @endcode
 *
*/
AbstractApplicationWindow {
    id: root

    /**
     * @property QtQuick.StackView ApplicationItem::pageStack
     *
     * @brief This property holds the stack used to allocate the pages and to
     * manage the transitions between them.
     *
     * It's using a PageRow, while having the same API as PageStack,
     * it positions the pages as adjacent columns, with as many columns
     * as can fit in the screen. An handheld device would usually have a single
     * fullscreen column, a tablet device would have many tiled columns.
     *
     * @warning This property is not currently readonly, but it should be treated like it is readonly.
     */
    property alias pageStack: __pageStack // TODO KF6 make readonly

    // Redefined here as here we can know a pointer to PageRow.
    // We negate the canBeEnabled check because we don't want to factor in the automatic drawer provided by Kirigami for page actions for our calculations
    wideScreen: width >= (root.pageStack.defaultColumnWidth) + ((contextDrawer && !(contextDrawer instanceof Kirigami.ContextDrawer)) ? contextDrawer.width : 0) + (globalDrawer ? globalDrawer.width : 0)

    Component.onCompleted: {
        if (pageStack.currentItem) {
            pageStack.currentItem.forceActiveFocus()
        }
    }

    PageRow {
        id: __pageStack
        globalToolBar.style: Kirigami.ApplicationHeaderStyle.Auto
        anchors {
            fill: parent
            //HACK: workaround a bug in android iOS keyboard management
            bottomMargin: ((Qt.platform.os == "android" || Qt.platform.os == "ios") || !Qt.inputMethod.visible) ? 0 : Qt.inputMethod.keyboardRectangle.height
            onBottomMarginChanged: {
                if (__pageStack.anchors.bottomMargin > 0) {
                    root.reachableMode = false;
                }
            }
        }
        //FIXME
        onCurrentIndexChanged: root.reachableMode = false;

        focus: true
    }
}
