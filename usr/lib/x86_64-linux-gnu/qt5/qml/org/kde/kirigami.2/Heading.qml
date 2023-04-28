/*
 *  SPDX-FileCopyrightText: 2012 by Sebastian Kügler <sebas@kde.org>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.0
import QtQuick.Controls 2.0 as QQC2
import org.kde.kirigami 2.4

/**
 * A heading label used for subsections of texts.
 *
 * The characteristics of the text will be automatically set according to the
 * Theme. Use this components for section titles or headings in your UI,
 * for example page or section titles.
 *
 * Example usage:
 *
 * @code
 * import org.kde.kirigami 2.4 as Kirigami
 * [...]
 * Column {
 *     Kirigami.Heading {
 *         text: "Apples in the sunlight"
 *         level: 2
 *     }
 *   [...]
 * }
 * @endcode
 *
 * The most important property is "text", which applies to the text property of
 * Label. See the Label component from QtQuick.Controls 2 and primitive QML Text
 * element API for additional properties, methods and signals.
 *
 * @inherit QtQuick.Controls.Label
 */
QQC2.Label {
    id: heading

    /**
     * The level determines how big the section header is display, values
     * between 1 (big) and 5 (small) are accepted. (default: 1)
     */
    property int level: 1

    /**
     * Adjust the point size in between a level and another. (default: 0)
     * @deprecated
     */
    property int step: 0

    enum Type {
        Normal,
        Primary,
        Secondary
    }

    /**
     * The type of the heading. This can be:
     *
     * * Kirigami.Heading.Type.Normal: Create a normal heading (default)
     * * Kirigami.Heading.Type.Primary: Makes the heading more prominent. Useful
     *   when making the heading bigger is not enough.
     * * Kirigami.Heading.Type.Secondary: Makes the heading less prominent.
     *   Useful when an heading is for a less important section in an application.
     *
     * @since 5.82
     */
    property int type: Heading.Type.Normal

    font.pointSize: __headerPointSize(level)
    font.weight: type === Heading.Type.Primary ? Font.DemiBold : Font.Normal

    opacity: type === Heading.Type.Secondary ? 0.7 : 1

    Accessible.role: Accessible.Heading

    // TODO KF6: Remove this public method
    function headerPointSize(l) {
        console.warn("org.kde.plasma.extras/Heading::headerPointSize() is deprecated. Use font.pointSize directly instead");
        return __headerPointSize(l);
    }

    //
    //  W A R N I N G
    //  -------------
    //
    // This method is not part of the Kirigami API.  It exists purely as an
    // implementation detail.  It may change from version to
    // version without notice, or even be removed.
    //
    // We mean it.
    //
    function __headerPointSize(level) {
        const n = Theme.defaultFont.pointSize;
        switch (level) {
        case 1:
            return n * 1.35 + step;
        case 2:
            return n * 1.20 + step;
        case 3:
            return n * 1.15 + step;
        case 4:
            return n * 1.10 + step;
        default:
            return n + step;
        }
    }
}
