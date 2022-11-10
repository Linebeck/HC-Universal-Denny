CustomBlockLogic:
    type: world
    debug: false
    events:
        on player places mushroom_stem|brown_mushroom_block|red_mushroom_block:
            - determine passively cancelled
            - wait 1t
            - modifyblock <context.location> <player.item_in_hand.flag[enforcedblockstate].if_null[<player.item_in_hand.material.name>]> no_physics
            - if <context.item.script.name.if_null[null]> != null:
                - flag <context.location.block> item:<player.item_in_hand.script.name>
            - if <player.gamemode> != creative:
                - take iteminhand quantity:1
        on player breaks mushroom_stem|brown_mushroom_block|red_mushroom_block:
          - if <player.gamemode> != creative:
            - determine passively cancelled
            - drop <context.location.block.flag[item]> <context.location>
            - modifyblock <context.location> air
          - flag <context.location.block> item:!
        on *mushroom* physics:
            - determine cancelled
