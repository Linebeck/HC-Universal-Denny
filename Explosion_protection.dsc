HC_TNT_doesnt_explode:
    type: world
    debug: false
    events:
        on tnt primes:
            - if <context.entity.world.name> == creative:
                - determine passively cancelled
                - narrate "<red>TNT is disabled in this world!"