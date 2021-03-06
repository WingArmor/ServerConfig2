register_command('depower', 
    array(
        'description': 'Power',
        'permission': 'powers.depower',
        'noPermMsg': 'Sorry you don\'t have permission to use this command.',
        'executor': closure(@alias, @sender, @args) {
        
            if (array_size(@args) != 1) {
                return(false) 
            }
            @plr = player()
            @player = @args[0]
            @player = player(@player)
            if(ponline(@player)){
                if(has_permission(@player,'is.criminal')){
                    msg(color('RED').'Sorry, that player is a criminal right now, you please try again later.')
                    die()
                }

                if(!has_permission(@player,'is.incity') && !has_permission(@player,'in.survival')){
                    msg(color('RED').'You cannot mortal that player, they are busy in a minigame or some other protected area')
                    die()
                }
                if(has_permission(@player,'is.op')){
                    msg(color('RED').'You cannot mortal that player, they are way better than you,')
                    die()
                }
                include('/home/minecraft/server/plugins/CommandHelper/includes/coolDown.ms')
                if(_coolDown('lastUsedDepower',60,@plr)){
                    return()
                }
                
                export(@player.'nerfOnePunch',true)

                runas('~console',"/gamemode survival ".@player)
                runas('~console',"/minecraft:clear ".@player)
                runas('~console',"/minecraft:effect ".@player." clear")
                runas('~console',"/fly ".@player." off")
                runas(@player,'/fixskin')
                @theBind = bind('player_command',null,array('player':@player),@e, @vicc = @player){
                    cancel()
                    tmsg(@vicc,color('RED').'You have been temporarily stripped of your powers, you can\'t use any commands right now!')
                }

                include('/home/minecraft/server/plugins/CommandHelper/includes/getHeroClass.ms')
                @vicclass = _getheroclass(@player)
                try{
                    @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@vicclass.'.yml')
                    @hero = yml_decode(@contents)
                    @vicHero = @hero
                }catch(Exception @e){
                    @vicHero = array()
                    @vicHero['chat'][0]['name'] = @player
                }

                set_timeout(30000,closure(
                    unbind(@theBind)
                    export(@player.'nerfOnePunch',false)
                    tmsg(@player,color('RED').'Your powers are restored.')
                ))

                @plrclass = _getheroclass(@plr)
                try{
                    @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@plrclass.'.yml')
                    @hero = yml_decode(@contents)
                }catch(Exception @e){
                    @hero = array()
                    @hero['costumes'][0]['name'] = @plr
                }
                @plrHero = @hero
                set_timeout(3000,closure(
                    broadcast(color('LIGHT_PURPLE').color('BOLD').'POOF'.color('YELLOW').color('BOLD').'! '.@plrHero['chat'][0]['name'].color('RED').color('BOLD').' has stripped '.color('WHITE').@vicHero['chat'][0]['name'].color('RED').color('BOLD').' of their powers!');
                ))
            }
            
        }
    )
)
