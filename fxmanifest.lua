fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'vCore Framework'
description 'Modern UI Framework for vCore'
version '1.0.0'

ui_page 'html/index.html'

client_scripts {
    'client/*.lua'
}

files {
    'html/index.html'
}

exports {
    'OpenMenu',
    'CloseMenu',
    'OpenInput',
    'ShowSkillbar',
    'ShowProgressbar',
    'Notify'
}

dependencies {
    'vCore' -- Ensure vCore is loaded first
}