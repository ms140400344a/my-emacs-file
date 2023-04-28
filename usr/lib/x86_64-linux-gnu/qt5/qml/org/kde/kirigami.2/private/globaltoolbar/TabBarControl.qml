/*
 *  SPDX-FileCopyrightText: 2018 Marco Martin <mart@kde.org>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami

// TODO KF6 deprecated
Controls.TabBar {
    id: root
    property Kirigami.PageRow pageRow: parent.pageRow

    Repeater {
        id: mainRepeater
        model: pageRow.depth
        delegate: Controls.TabButton {
            anchors {
                top:parent.top
                bottom:parent.bottom
            }
            width: mainRepeater.count === 1 ? implicitWidth : Math.max(implicitWidth, Math.round(root.width/mainRepeater.count))
            height: root.height
            readonly property Kirigami.Page page: pageRow.get(modelData)
            text: page ? page.title : ""
            checked: modelData === pageRow.currentIndex
            onClicked: pageRow.currentIndex = modelData;
        }
    }
}
