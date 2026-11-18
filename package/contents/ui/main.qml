pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.plasmoid
import org.kde.plasma.private.sessions as Sessions

PlasmoidItem {
    id: root

    readonly property bool horizontal: Plasmoid.formFactor === PlasmaCore.Types.Horizontal
    readonly property bool vertical: Plasmoid.formFactor === PlasmaCore.Types.Vertical

    toolTipMainText: qsTr("Power Menu")
    preferredRepresentation: fullRepresentation

    Sessions.SessionManagement {
        id: session
    }

    fullRepresentation: PlasmaComponents.ToolButton {
        id: powerButton

        Layout.minimumWidth: root.horizontal ? height : Kirigami.Units.iconSizes.small
        Layout.minimumHeight: root.vertical ? width : Kirigami.Units.iconSizes.small
        Layout.preferredWidth: root.horizontal ? height : Kirigami.Units.iconSizes.large
        Layout.preferredHeight: root.vertical ? width : Kirigami.Units.iconSizes.large

        text: qsTr("Power Menu")
        display: QQC.AbstractButton.IconOnly
        icon.name: "system-shutdown-symbolic"
        icon.width: Kirigami.Units.iconSizes.smallMedium
        icon.height: Kirigami.Units.iconSizes.smallMedium

        onClicked: powerMenu.openRelative()

        PlasmaExtras.Menu {
            id: powerMenu

            visualParent: powerButton
            placement: {
                switch (root.plasmoid.location) {
                case PlasmaCore.Types.BottomEdge:
                    return PlasmaExtras.Menu.TopPosedLeftAlignedPopup
                case PlasmaCore.Types.LeftEdge:
                    return PlasmaExtras.Menu.RightPosedTopAlignedPopup
                case PlasmaCore.Types.RightEdge:
                    return PlasmaExtras.Menu.LeftPosedTopAlignedPopup
                default:
                    return PlasmaExtras.Menu.BottomPosedLeftAlignedPopup
                }
            }

            PlasmaExtras.MenuItem {
                text: qsTr("Shut Down")
                icon: "system-shutdown"
                enabled: session.canShutdown
                onClicked: session.requestShutdown(Sessions.SessionManagement.ForcePrompt)
            }

            PlasmaExtras.MenuItem {
                text: qsTr("Restart")
                icon: "system-reboot"
                enabled: session.canReboot
                onClicked: session.requestReboot(Sessions.SessionManagement.ForcePrompt)
            }

            PlasmaExtras.MenuItem {
                text: qsTr("Suspend")
                icon: "system-suspend"
                enabled: session.canSuspend
                onClicked: session.suspend()
            }

            PlasmaExtras.MenuItem {
                text: qsTr("Log Out")
                icon: "system-log-out"
                enabled: session.canLogout
                onClicked: session.requestLogout(Sessions.SessionManagement.ForcePrompt)
            }

            PlasmaExtras.MenuItem {
                text: qsTr("Lock Screen")
                icon: "system-lock-screen"
                enabled: session.canLock
                onClicked: session.lock()
            }
        }
    }
}
