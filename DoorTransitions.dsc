door_transitions:
        type: world
        debug: false
        events:
                on player right clicks *_door:
                        - if <context.block.material.name> == iron_door or <player.item_in_hand.script.name.if_null[]> == door_link_tool:
                                - stop
                        - if <context.location.block.has_flag[transitions]> and <player.item_in_hand.script.name.if_null[null]> != door_transitions_tool:
                                - run cutscene_screeneffect def.player:<player> def.fade_in:0.5s def.stay:1s def.fade_out:0.5s def.color:<black>
                                - wait 10t
                                - switch <context.location>
                                - teleport <player> <context.location.block.flag[transitions]>
                on player breaks block:
                    - if <context.location.block.has_flag[transitions]>:
                        - flag <context.location.block> transitions:!
                        - flag <context.location.other_block.block> transitions:!

#Door tool


cutscene_screeneffect:
    type: task
    debug: false
    config:
        cutscene_transition_unicode: \ue813
    definitions: player|fade_in|stay|fade_out|color
    script:
    - if <&color[<[color]>]||null> == null:
      - define color <black>
    - define title <script[cutscene_screeneffect].data_key[config].get[cutscene_transition_unicode]||null>
    - if <[title]> == null:
      - debug error "Could not find screeneffect unicode in cutscene_screeneffect"
      - stop
    - title title:<&color[<[color]>]||<black>><[title]> fade_in:<duration[<[fade_in]>]> stay:<duration[<[stay]>]> fade_out:<duration[<[fade_out]>]> targets:<[player]>


door_link_tool:
    type: item
    debug: false
    material: wooden_hoe
    data:
        discover: false
    flags:
        uuid: <util.random_uuid>
    display name: <reset><gold>Door Tool
    lore:
        - <reset><gray>Click two doors to link them
    mechanisms:
        hides:
            - ENCHANTS
    enchantments:
        - luck: 4

door_link_tool_script:
        type: world
        debug: false
        events:
                on player right clicks *_door with:door_link_tool:
                        - if <player.is_sneaking>:
                            - determine passively cancelled
                            - switch <context.location>
                            - stop
                        - if <player.item_in_hand.flag[DoorWarpStep]> >= 2:
                            - determine passively cancelled

                            - define door1 <player.item_in_hand.flag[location1]>
                            - define door2 <context.location>

                            - flag <[door1].block> transitions:<[door2].with_facing_direction.forward_flat[1]>
                            - flag <[door2].block> transitions:<[door1].with_facing_direction.forward_flat[1]>
                            - flag <[door1].other_block.block> transitions:<[door2].with_facing_direction.forward_flat[1]>
                            - flag <[door2].other_block.block> transitions:<[door1].with_facing_direction.forward_flat[1]>

                            - inventory flag slot:hand DoorWarpStep:!
                            - narrate "<white>[<green>Door Tool<white>] Doors Linked"
                            - stop
                        - determine passively cancelled
                        - inventory flag slot:hand location1:<context.location>
                        - inventory flag slot:hand DoorWarpStep:2
                        - narrate "<white>[<green>Door Tool<white>] Location 1 set"