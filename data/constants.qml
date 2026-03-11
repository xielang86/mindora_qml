pragma Singleton
import QtQuick 2.15

QtObject {    
    property var pageImages: [
        ["resources/images/firstmenu_Sleep.png", "resources/images/firstmenu_Alarm.png", "resources/images/firstmenu_Sound.png"],
        ["resources/images/firstmenu_Meditation.png", "resources/images/firstmenu_SleepAnalysis.png", "resources/images/firstmenu_Settings.png"]
    ]

    property var sleepMenuData: [
        { 
            bg: "resources/images/sleepAid_recommended_marked_Back.png", 
            title: "Your like", 
            describtion: "Here are your bedtime preferences and new content\nrecommendations. Quickly fnd the sleep aid materi-\nals that suit you best.",
            btns: "Home,Enter" 
        },
        { 
            bg: "resources/images/sleepAid_sceneAid_Back.png", 
            title: "Sleep Scenario",  
            describtion: "Using technology to recreate the healing frequencies\nof the world's natural sacred sites, guiding you step\nby step into a deep sleep.",
            btns: "Home,Enter" 
        },
        { 
            bg: "resources/images/sleepAid_sleepAgain_Back.png", 
            title: "Fall Asleep Again",  
            describtion: "Whether you're struggling to fall asleep or waking up\nin the middle of the night, it helps you get back to\nsleep quickly.",
            btns: "Home,Enter" 
        },
        { 
            bg: "resources/images/sleepAid_pureMusic_Back.png", 
            title: "Pure Music",  
            describtion: "Purely natural, primordial frequencies,ideal for ex-\ntended use in aiding sleep or enhancing focus.",
            btns: "Home,Enter" 
        },
        { 
            bg: "resources/images/sleepAid_sleepTraining_Back.png", 
            title: "Sleep Training",  
            describtion: "Systematically improve your sleep quality through\nmeditation practice.",
            btns: "Home,Enter" 
        }
    ]

    property var scenarioMenuData: [
        {
            title: "Maldives Drift Sleep", 
            describtion: "",
            icon: "resources/images/Scene_sleepAid_Scenario_Maldives_icon.png", 
            process: 
            [
                ["resources/images/Scene_sleepAid_Scenario_Maldives_main.png"], 
                ["resources/images/Scene_sleepAid_Scenario_Maldives_breath.png"], 
                ["resources/images/Scene_sleepAid_Scenario_Maldives_scan.png"], 
                ["resources/images/Scene_sleepAid_Scenario_Maldives_goodnight.png"]
            ],
            cmd: "sleep.scene.cocos_island_moonlight"
            
        },
        {
            title: "Amalfi Coast Breeze", 
            describtion: "",
            icon: "resources/images/Scene_sleepAid_Scenario_Amalfi_icon.png", 
            process: 
            [
                ["resources/images/Scene_sleepAid_Scenario_Amalfi_main.png"], 
                ["resources/images/Scene_sleepAid_Scenario_Amalfi_breath.png"], 
                ["resources/images/Scene_sleepAid_Scenario_Amalfi_scan.png"], 
                ["resources/images/Scene_sleepAid_Scenario_Amalfi_goodnight.png"]
            ],
            cmd: "sleep.scene.amalfi_breeze"      
        },
        {
            title: "Kyoto Temple Stillness", 
            describtion: "",
            icon: "resources/images/Scene_sleepAid_Scenario_Kyoto_icon.png", 
            process: 
            [
                ["resources/images/Scene_sleepAid_Scenario_Kyoto_main.png"], 
                ["resources/images/Scene_sleepAid_Scenario_Kyoto_breath.png"], 
                ["resources/images/Scene_sleepAid_Scenario_Kyoto_scan.png"], 
                ["resources/images/Scene_sleepAid_Scenario_Kyoto_goodnight.png"]
            ],
            cmd: "sleep.scene.kyoto_forest"
        },
        {
            title: "Andaman Rain Retreat", 
            describtion: "",
            icon: "resources/images/Scene_sleepAid_Scenario_Andaman_icon.png", 
            process: 
            [
                ["resources/images/Scene_sleepAid_Scenario_Andaman_main.png"], 
                ["resources/images/Scene_sleepAid_Scenario_Andaman_breath.png"], 
                ["resources/images/Scene_sleepAid_Scenario_Andaman_scan.png"], 
                ["resources/images/Scene_sleepAid_Scenario_Andaman_goodnight.png"]
            ],
            cmd: "sleep.scene.andaman_rainforest_sanctuary"
        },
        {
            title: "Bhutan Cloud Forest", 
            describtion: "",
            icon: "resources/images/Scene_sleepAid_Scenario_Bhutan_icon.png", 
            process: 
            [
                ["resources/images/Scene_sleepAid_Scenario_Bhutan_main.png"], 
                ["resources/images/Scene_sleepAid_Scenario_Bhutan_breath.png"], 
                ["resources/images/Scene_sleepAid_Scenario_Bhutan_scan.png"], 
                ["resources/images/Scene_sleepAid_Scenario_Bhutan_goodnight.png"]
            ],
            cmd: "sleep.scene.bhutan_misty_forest"  
        },
        {
            title: "Sedona Desert Calm", 
            describtion: "",
            icon: "resources/images/Scene_sleepAid_Scenario_Sedona_icon.png", 
            process: 
            [
                ["resources/images/Scene_sleepAid_Scenario_Sedona_main.png"], 
                ["resources/images/Scene_sleepAid_Scenario_Sedona_breath.png"], 
                ["resources/images/Scene_sleepAid_Scenario_Sedona_scan.png"], 
                ["resources/images/Scene_sleepAid_Scenario_Sedona_goodnight.png"]
            ],
            cmd: "sleep.scene.sedona_red_rock_peace"  
        },
        {
            title: "Canadian Forest Solace", 
            describtion: "",
            icon: "resources/images/Scene_sleepAid_Scenario_Canadian_icon.png", 
            process: 
            [
                ["resources/images/Scene_sleepAid_Scenario_Canadian_main.png"], 
                ["resources/images/Scene_sleepAid_Scenario_Canadian_breath.png"], 
                ["resources/images/Scene_sleepAid_Scenario_Canadian_scan.png"], 
                ["resources/images/Scene_sleepAid_Scenario_Canadian_goodnight.png"]
            ],
            cmd: "sleep.scene.fogo_island_cookie_box"  
        },
        {
            title: "South African Star Dune", 
            describtion: "",
            icon: "resources/images/Scene_sleepAid_Scenario_SouthAfrican_icon.png", 
            process: 
            [
                ["resources/images/Scene_sleepAid_Scenario_SouthAfrican_main.png"], 
                ["resources/images/Scene_sleepAid_Scenario_SouthAfrican_breath.png"], 
                ["resources/images/Scene_sleepAid_Scenario_SouthAfrican_scan.png"], 
                ["resources/images/Scene_sleepAid_Scenario_SouthAfrican_goodnight.png"]
            ],
            cmd: "sleep.yoga_nidra.deep_sleep"
        },
        {
            title: "Seychelles Coral Lullaby", 
            describtion: "",
            icon: "resources/images/Scene_sleepAid_Scenario_Seychelles_icon.png", 
            process: 
            [
                ["resources/images/Scene_sleepAid_Scenario_Seychelles_main.png"], 
                ["resources/images/Scene_sleepAid_Scenario_Seychelles_breath.png"], 
                ["resources/images/Scene_sleepAid_Scenario_Seychelles_scan.png"], 
                ["resources/images/Scene_sleepAid_Scenario_Seychelles_goodnight.png"]
            ],
            cmd: "sleep.scene.seychelles_moonlight_lullaby" 
        },
        {
            title: "Swiss Alpine Meadow", 
            describtion: "",
            icon: "resources/images/Scene_sleepAid_Scenario_Swiss_icon.png", 
            process: 
            [
                ["resources/images/Scene_sleepAid_Scenario_Swiss_main.png"], 
                ["resources/images/Scene_sleepAid_Scenario_Swiss_breath.png"], 
                ["resources/images/Scene_sleepAid_Scenario_Swiss_scan.png"], 
                ["resources/images/Scene_sleepAid_Scenario_Swiss_goodnight.png"]
            ],
            cmd: "sleep.yoga_nidra.deep_sleep"
        }
    ]
}
