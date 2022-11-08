resource_reload_manual:
    type: command
    usage: /resourcereload
    name: resourcereload
    permission: public
    description: Redownloads the resource pack
    script:
        - ~run resource_reload instantly



resource_reload_auto:
    type: world
    debug: false
    events:
        on player joins:
            - if <player.has_flag[dev.resource]>:
                - ~run resource_reload instantly


resource_reload:
    type: task
    debug: false
    script:
        - narrate "<green>Redownloading Resources...."
        - resourcepack url:<yaml[ResourcePack].read[ResourcePack.URL]> hash:<yaml[ResourcePack].read[ResourcePack.Hash]> targets:<player> forced


resource_update_manual:
    type: command
    usage: /resourceupdate
    name: resourceupdate
    permission: admin.tools
    tab completions:
        1: URL
        2: announce
        3: decompress
    description: Updates the resource pack URL and Hash
    script:

        #Config
        - define PackSavePath plugins/Denizen/data/ResourcePack.zip

        #Verify input
        - if <context.args.get[1].if_null[null]> != null and <context.args.get[1].contains_text[.zip]>:

            #Start Download
            - ~webget <context.args.get[1]> savefile:<[PackSavePath]> save:result hide_failure


            #Print failure
            - if <entry[result].status.if_null[null]> != 200:
                - narrate "<red>Download failed <red><n><white><entry[result].status.if_null[No response from remote server]>"
                - stop

            #Decompress locally

            - if <context.args.get[3].if_null[null]> == decompress:
                - narrate W.I.P


            #Hash file
            - ~fileread path:<[PackSavePath]> save:File
            - define Hash <entry[File].hash[SHA-1].if_null[null]>
            - if <[Hash]> == null:
                - narrate "<red>Unable to read file for hashing. Random hash will be generated, this will not be the file hash."
                - define Hash <util.random_uuid.base64_encode.base64_to_binary.hash[SHA-1].replace_text[binary@].if_null[null]>
            - narrate "<green>Pack updated:<n><reset> <green>Hash: <white><[Hash]>"

            #Save Details to YAML
            - ~yaml create id:ResourcePack
            - ~yaml load:configs/ResourcePack.yml id:ResourcePack
            - ~yaml set id:ResourcePack ResourcePack.Hash:<[Hash]>
            - ~yaml set id:ResourcePack ResourcePack.URL:<context.args.get[1]>
            - ~yaml savefile:configs/ResourcePack.yml id:ResourcePack

            #Announce to server
            - if <context.args.get[2].if_null[null]> == announce:
                - clickable save:OnClickCommand until:45s usages:1:
                    - ~run resource_reload instantly
                - narrate targets:<server.online_players> "<green>The Resource Pack has been updated, please run <white><element[/ResourceReload].on_click[<entry[OnClickCommand].command>]><reset> <green> to download and use the new pack."

        - else:
            - narrate "<red>That is not a valid direct link"