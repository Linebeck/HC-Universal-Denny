HC_trash_command:
    type: command
    usage: /trash
    name: trash
    permission: hc.user
    description: "trash"
    script:
        - inventory open d:generic[size=27;title=<dark_gray>Trash]

HC_give_customblock_command:
    type: command
    debug: false
    usage: /getblock
    name: getblock
    permission: builder
    description: Grabs a custom block
    tab complete:
        - foreach <util.scripts>:
            - if <[value].contains_text[HC_customblock]> and !<[value].contains_text[_script]>:
                - define item <[value].name.replace_text[HC_customblock_]>
                - define list:->:<[item]>
        - determine <[list]>
    script:
        - if <player.gamemode> == creative:
            - define arg1 HC_customblock_<context.args.get[1]>
            - define arg2 <context.args.get[2]>
            - if <script[<[arg1]>].exists>:
                - give <[arg1]> quantity:<[arg2]>
            - else:
                - narrate "<red>That is not a valid custom item"

        - else:
            - narrate "<red>This command only works in creative mode"


HC_give_customenchantedbook_command:
    type: command
    debug: false
    usage: /getbook
    name: getbook
    permission: builder
    description: Grabs a custom enchanted book
    tab complete:
        - foreach <util.scripts>:
            - if <[value].contains_text[HC_enchantment_]> and !<[value].contains_text[_script]>:
                - define item <[value].name.replace_text[HC_enchantment_]>
                - define list:->:<[item]>
        - determine <[list]>
    script:
        - if <player.gamemode> == creative:
            - define arg1 <context.args.get[1].replace_text[HC_enchantment_]>
            - define arg2 <context.args.get[2]>
            - give enchanted_book[enchantments=<[arg1]>,1;lore=<reset><gray><[arg1]>] quantity:<[arg2].if_null[1]>
        - else:
            - narrate "<red>This command only works in creative mode"

HC_give_customitem_command:
    type: command
    debug: false
    usage: /getitem
    name: getitem
    permission: builder
    description: Grabs a custom item
    tab complete:
        - foreach <util.scripts>:
            - if <script[<[value]>].data_key[type]> == item:
                - define item <[value].name>
                - define list:->:<[item]>
        - determine <[list]>
    script:
        - define item <context.args.get[1]>
        - if <script[<[item]>].exists>:
            - give <[item]> quantity:<context.args.get[2].if_null[1]>

HC_list_custommodeldata_command:
    type: command
    debug: false
    usage: /lcmd
    name: lcmd
    permission: builder
    description: Shows all items with custom model data
    tab complete:
        - foreach <server.material_types.parse[item]>:
            - define item <[value].as[item].material.name>
            - define list:->:<[item]>
        - determine <[list]>
    script:
    - define arg1 <context.args.get[1]>
    - if <server.material_types.parse[item].contains_text[<[arg1]>]>:
        - flag <player> HC_list_custommodeldata_menu_data:<[arg1]>
        - inventory open d:HC_list_custommodeldata_menu

HC_list_custommodeldata_menu:
    debug: false
    type: inventory
    inventory: chest
    title: <reset><bold><green>Custom Model Data
    procedural items:
    - define item <player.flag[HC_list_custommodeldata_menu_data].as[item]>
    - repeat 54:
        - define item2 "<[item].material.name>[custom_model_data=<[value]>;display=<reset><[item].material.name.replace_text[_].with[ ]> <green><[value]>]"
        - define list:->:<[item2]>
    - determine passively <[list]>
    gui: true
    slots:
        - [] [] [] [] [] [] [] [] []
        - [] [] [] [] [] [] [] [] []
        - [] [] [] [] [] [] [] [] []
        - [] [] [] [] [] [] [] [] []
        - [] [] [] [] [] [] [] [] []
        - [] [] [] [] [] [] [] [] []