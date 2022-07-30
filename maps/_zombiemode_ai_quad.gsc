#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility;
#include animscripts\zombie_Utility;
init()
{
	init_quad_zombie_anims();
	
	level.quad_spawners = GetEntArray( "quad_zombie_spawner", "script_noteworthy" );
	array_thread( level.quad_spawners, ::add_spawn_function, maps\_zombiemode_ai_quad::quad_prespawn );
}
wait_for_leap()
{
	while ( 1 )
	{
		wait( 5 );
		self.custom_attack = true;
		wait( .5 );
		self.custom_attack = false;
	}
}
#using_animtree( "generic_human" );
quad_prespawn()
{
	self.animname = "quad_zombie";
	
	self.custom_idle_setup = maps\_zombiemode_ai_quad::quad_zombie_idle_setup;
	
	self.a.idleAnimOverrideArray = [];
	self.a.idleAnimOverrideArray["stand"] = [];
	self.a.idleAnimOverrideArray["stand"] = [];
	self.a.idleAnimOverrideArray["stand"][0][0] 	= %ai_zombie_quad_idle;
	self.a.idleAnimOverrideWeights["stand"][0][0] 	= 10;
	self.a.idleAnimOverrideArray["stand"][0][1] 	= %ai_zombie_quad_idle_2;
	self.a.idleAnimOverrideWeights["stand"][0][1] 	= 10;
	self.no_eye_glow = true;
	
	self maps\_zombiemode_spawner::zombie_spawn_init( true );
	
	self.maxhealth = int( self.maxhealth * 0.75 );
	self.health = self.maxhealth;
	self.freezegun_damage = 0;
	self.meleeDamage = 45;
	
	self playsound( "zmb_quad_spawn" );
	
	
	self.death_explo_radius_zomb        = 96;      
    self.death_explo_radius_plr         = 96;      
    self.death_explo_damage_zomb        = 1.05;     
    self.death_gas_radius               = 125;      
    self.death_gas_time                 = 7;        
	if ( isdefined( level.quad_explode ) && level.quad_explode == true )
	{
		self.deathanimscript = ::quad_post_death;
		self.actor_killed_override = ::quad_killed_override;
	}
	self set_default_attack_properties();
	self.thundergun_disintegrate_func = ::quad_thundergun_disintegrate;
	self.thundergun_knockdown_func = ::quad_thundergun_knockdown;
	
	self.pre_teleport_func = ::quad_pre_teleport;
	self.post_teleport_func = ::quad_post_teleport;
	self.can_explode = false;
	self.exploded = false;
	self thread quad_trail();
	self AllowPitchAngle(1);
	
	if ( isdefined( level.quad_traverse_death_fx ) )
	{
		self thread [[ level.quad_traverse_death_fx ]]();
	}
	
	self setPhysParams( 15, 0, 24 );
}
quad_zombie_idle_setup()
{
	
	self.a.array["turn_left_45"] = %exposed_tracking_turn45L;
	self.a.array["turn_left_90"] = %exposed_tracking_turn90L;
	self.a.array["turn_left_135"] = %exposed_tracking_turn135L;
	self.a.array["turn_left_180"] = %exposed_tracking_turn180L;
	self.a.array["turn_right_45"] = %exposed_tracking_turn45R;
	self.a.array["turn_right_90"] = %exposed_tracking_turn90R;
	self.a.array["turn_right_135"] = %exposed_tracking_turn135R;
	self.a.array["turn_right_180"] = %exposed_tracking_turn180L;
	self.a.array["exposed_idle"] = array( %ai_zombie_quad_idle, %ai_zombie_quad_idle_2 );		
	self.a.array["straight_level"] = %ai_zombie_quad_idle;
	self.a.array["stand_2_crouch"] = %ai_zombie_shot_leg_right_2_crawl;
}
init_quad_zombie_anims()
{
	
	level.scr_anim["quad_zombie"]["death1"] 	= %ai_zombie_quad_death;
	level.scr_anim["quad_zombie"]["death2"] 	= %ai_zombie_quad_death_2;
	level.scr_anim["quad_zombie"]["death3"] 	= %ai_zombie_quad_death_3;
	level.scr_anim["quad_zombie"]["death4"] 	= %ai_zombie_quad_death_4;
	
	level.scr_anim["quad_zombie"]["walk1"] 	= %ai_zombie_quad_crawl;
	level.scr_anim["quad_zombie"]["walk2"] 	= %ai_zombie_quad_crawl;
	level.scr_anim["quad_zombie"]["walk3"] 	= %ai_zombie_quad_crawl;
	level.scr_anim["quad_zombie"]["walk4"] 	= %ai_zombie_quad_crawl_2;
	level.scr_anim["quad_zombie"]["walk5"] 	= %ai_zombie_quad_crawl_2;
	level.scr_anim["quad_zombie"]["walk6"] 	= %ai_zombie_quad_crawl_3;
	level.scr_anim["quad_zombie"]["walk7"] 	= %ai_zombie_quad_crawl_3;
	level.scr_anim["quad_zombie"]["walk8"] 	= %ai_zombie_quad_crawl_3;
	level.scr_anim["quad_zombie"]["run1"] 	= %ai_zombie_quad_crawl_run;
	level.scr_anim["quad_zombie"]["run2"] 	= %ai_zombie_quad_crawl_run_2;
	level.scr_anim["quad_zombie"]["run3"] 	= %ai_zombie_quad_crawl_run_3;
	level.scr_anim["quad_zombie"]["run4"] 	= %ai_zombie_quad_crawl_run_4;
	level.scr_anim["quad_zombie"]["run5"] 	= %ai_zombie_quad_crawl_run_5;
	level.scr_anim["quad_zombie"]["run6"] 	= %ai_zombie_quad_crawl_run;
	level.scr_anim["quad_zombie"]["sprint1"] = %ai_zombie_quad_crawl_sprint;
	level.scr_anim["quad_zombie"]["sprint2"] = %ai_zombie_quad_crawl_sprint_2;
	level.scr_anim["quad_zombie"]["sprint3"] = %ai_zombie_quad_crawl_sprint_3;
	level.scr_anim["quad_zombie"]["sprint4"] = %ai_zombie_quad_crawl_sprint;
	
	level.scr_anim["quad_zombie"]["crawl1"] 	= %ai_zombie_quad_crawl_01;
	level.scr_anim["quad_zombie"]["crawl2"] 	= %ai_zombie_quad_crawl_01;
	level.scr_anim["quad_zombie"]["crawl3"] 	= %ai_zombie_quad_crawl_02;
	level.scr_anim["quad_zombie"]["crawl4"] 	= %ai_zombie_quad_crawl_02;
	level.scr_anim["quad_zombie"]["crawl5"] 	= %ai_zombie_quad_crawl_03;
	level.scr_anim["quad_zombie"]["crawl6"] 	= %ai_zombie_quad_crawl_03;
	level.scr_anim["quad_zombie"]["crawl_hand_1"] = %ai_zombie_walk_on_hands_a;
	level.scr_anim["quad_zombie"]["crawl_hand_2"] = %ai_zombie_walk_on_hands_b;
	level.scr_anim["quad_zombie"]["crawl_sprint1"] 	= %ai_zombie_crawl_sprint;
	level.scr_anim["quad_zombie"]["crawl_sprint2"] 	= %ai_zombie_crawl_sprint_1;
	level.scr_anim["quad_zombie"]["crawl_sprint3"] 	= %ai_zombie_crawl_sprint_2;
	if( !isDefined( level._zombie_melee ) )
	{
		level._zombie_melee = [];
	}
	if( !isDefined( level._zombie_walk_melee ) )
	{
		level._zombie_walk_melee = [];
	}
	if( !isDefined( level._zombie_run_melee ) )
	{
		level._zombie_run_melee = [];
	}
	level._zombie_melee["quad_zombie"] = [];
	level._zombie_walk_melee["quad_zombie"] = [];
	level._zombie_run_melee["quad_zombie"] = [];
	level._zombie_melee["quad_zombie"][0] 					= %ai_zombie_quad_attack; 
	level._zombie_melee["quad_zombie"][1] 					= %ai_zombie_quad_attack_2; 
	level._zombie_melee["quad_zombie"][2] 					= %ai_zombie_quad_attack_3; 
	level._zombie_melee["quad_zombie"][3] 					= %ai_zombie_quad_attack_4;	
	level._zombie_melee["quad_zombie"][4]						= %ai_zombie_quad_attack_5;
	level._zombie_melee["quad_zombie"][5]						= %ai_zombie_quad_attack_6;
	level._zombie_melee["quad_zombie"][6]						= %ai_zombie_quad_attack_double;
	level._zombie_melee["quad_zombie"][7]						= %ai_zombie_quad_attack_double_2;
	level._zombie_melee["quad_zombie"][8]						= %ai_zombie_quad_attack_double_3;
	level._zombie_melee["quad_zombie"][9]						= %ai_zombie_quad_attack_double_4;
	level._zombie_melee["quad_zombie"][10]						= %ai_zombie_quad_attack_double_5;
	level._zombie_melee["quad_zombie"][11]						= %ai_zombie_quad_attack_double_6;
	
	if( isDefined( level.quad_zombie_anim_override ) )
	{
		[[ level.quad_zombie_anim_override ]]();
	}
	
	if( !isDefined( level._zombie_melee_crawl ) )
	{
		level._zombie_melee_crawl = [];
	}
	level._zombie_melee_crawl["quad_zombie"] = [];
	level._zombie_melee_crawl["quad_zombie"][0] 		= %ai_zombie_attack_crawl; 
	level._zombie_melee_crawl["quad_zombie"][1] 		= %ai_zombie_attack_crawl_lunge;
	if( !isDefined( level._zombie_stumpy_melee ) )
	{
		level._zombie_stumpy_melee = [];
	}
	level._zombie_stumpy_melee["quad_zombie"] = [];
	level._zombie_stumpy_melee["quad_zombie"][0] = %ai_zombie_walk_on_hands_shot_a;
	level._zombie_stumpy_melee["quad_zombie"][1] = %ai_zombie_walk_on_hands_shot_b;
	
	if( !isDefined( level._zombie_tesla_death ) )
	{
		level._zombie_tesla_death = [];
	}
	level._zombie_tesla_death["quad_zombie"] = [];
	level._zombie_tesla_death["quad_zombie"][0] = %ai_zombie_quad_death_tesla;
	level._zombie_tesla_death["quad_zombie"][1] = %ai_zombie_quad_death_tesla_2;
	level._zombie_tesla_death["quad_zombie"][2] = %ai_zombie_quad_death_tesla_3;
	level._zombie_tesla_death["quad_zombie"][3] = %ai_zombie_quad_death_tesla_4;
	if( !isDefined( level._zombie_tesla_crawl_death ) )
	{
		level._zombie_tesla_crawl_death = [];
	}
	level._zombie_tesla_crawl_death["quad_zombie"] = [];
	level._zombie_tesla_crawl_death["quad_zombie"][0] = %ai_zombie_tesla_crawl_death_a;
	level._zombie_tesla_crawl_death["quad_zombie"][1] = %ai_zombie_tesla_crawl_death_b;
	
	if( !isDefined( level._zombie_freezegun_death ) )
	{
		level._zombie_freezegun_death = [];
	}
	level._zombie_freezegun_death["quad_zombie"] = [];
	level._zombie_freezegun_death["quad_zombie"][0] = %ai_zombie_quad_freeze_death_a;
	level._zombie_freezegun_death["quad_zombie"][1] = %ai_zombie_quad_freeze_death_b;
	
	if( !isDefined( level._zombie_deaths ) )
	{
		level._zombie_deaths = [];
	}
	level._zombie_deaths["quad_zombie"] = [];
	level._zombie_deaths["quad_zombie"][0] = %ai_zombie_quad_death;
	level._zombie_deaths["quad_zombie"][1] = %ai_zombie_quad_death_2;
	level._zombie_deaths["quad_zombie"][2] = %ai_zombie_quad_death_3;
	level._zombie_deaths["quad_zombie"][3] = %ai_zombie_quad_death_4;
	level._zombie_deaths["quad_zombie"][4] = %ai_zombie_quad_death_5;
	level._zombie_deaths["quad_zombie"][5] = %ai_zombie_quad_death_6;
	
	if( !isDefined( level._zombie_rise_anims ) )
	{
		level._zombie_rise_anims = [];
	}
	
	level._zombie_rise_anims["quad_zombie"] = [];
	level._zombie_rise_anims["quad_zombie"][1]["walk"][0]		= %ai_zombie_quad_traverse_ground_crawlfast;
	level._zombie_rise_anims["quad_zombie"][1]["run"][0]		= %ai_zombie_quad_traverse_ground_crawlfast;
	level._zombie_rise_anims["quad_zombie"][1]["sprint"][0]	= %ai_zombie_quad_traverse_ground_crawlfast;
	level._zombie_rise_anims["quad_zombie"][2]["walk"][0]		= %ai_zombie_quad_traverse_ground_crawlfast;
	
	if( !isDefined( level._zombie_rise_death_anims ) )
	{
		level._zombie_rise_death_anims = [];
	}
	
	level._zombie_rise_death_anims["quad_zombie"] = [];
	level._zombie_rise_death_anims["quad_zombie"][1]["in"][0]		= %ai_zombie_traverse_ground_v1_deathinside;
	level._zombie_rise_death_anims["quad_zombie"][1]["in"][1]		= %ai_zombie_traverse_ground_v1_deathinside_alt;
	level._zombie_rise_death_anims["quad_zombie"][1]["out"][0]		= %ai_zombie_traverse_ground_v1_deathoutside;
	level._zombie_rise_death_anims["quad_zombie"][1]["out"][1]		= %ai_zombie_traverse_ground_v1_deathoutside_alt;
	level._zombie_rise_death_anims["quad_zombie"][2]["in"][0]		= %ai_zombie_traverse_ground_v2_death_low;
	level._zombie_rise_death_anims["quad_zombie"][2]["in"][1]		= %ai_zombie_traverse_ground_v2_death_low_alt;
	level._zombie_rise_death_anims["quad_zombie"][2]["out"][0]		= %ai_zombie_traverse_ground_v2_death_high;
	level._zombie_rise_death_anims["quad_zombie"][2]["out"][1]		= %ai_zombie_traverse_ground_v2_death_high_alt;
	
	
	if( !isDefined( level._zombie_run_taunt ) )
	{
		level._zombie_run_taunt = [];
	}
	if( !isDefined( level._zombie_board_taunt ) )
	{
		level._zombie_board_taunt = [];
	}
	level._zombie_run_taunt["quad_zombie"] = [];
	level._zombie_board_taunt["quad_zombie"] = [];
	
	level._zombie_board_taunt["quad_zombie"][0] = %ai_zombie_quad_taunt;
	level._zombie_board_taunt["quad_zombie"][1] = %ai_zombie_quad_taunt_2;
	level._zombie_board_taunt["quad_zombie"][2] = %ai_zombie_quad_taunt_3;
	level._zombie_board_taunt["quad_zombie"][3] = %ai_zombie_quad_taunt_4;
	level._zombie_board_taunt["quad_zombie"][4] = %ai_zombie_quad_taunt_5;
	level._zombie_board_taunt["quad_zombie"][5] = %ai_zombie_quad_taunt_6;
	
	level._effect[ "quad_explo_gas" ]		        = LoadFX( "maps/zombie/fx_zombie_quad_gas_nova6" );
	level._effect[ "quad_trail" ]					= Loadfx( "maps/zombie/fx_zombie_quad_trail" );
}
quad_vox()
{
	self endon( "death" );
	
	wait( 5 );
	
	quad_wait = 5;
	
	while(1)
	{
		players = getplayers();
		
		for(i=0;i<players.size;i++)
		{
			if(DistanceSquared(self.origin, players[i].origin) > 1200 * 1200)
			{
				self playsound( "zmb_quad_amb" );	
				quad_wait = 7;		
			}
			else if(DistanceSquared(self.origin, players[i].origin) > 200 * 200)
			{
				self playsound( "zmb_quad_vox" );	
				quad_wait = 5;		
			}
			else if(DistanceSquared(self.origin, players[i].origin) < 150 * 150)
			{
				wait(.05);
			}
		}
		wait randomfloatrange( 1, quad_wait );		
	}
}
quad_close()
{
	self endon( "death" );
	
	while(1)
	{
		players = getplayers();
		
		for(i=0;i<players.size;i++)
		{
			if ( is_player_valid( players[i], true ) )
			{
				if(DistanceSquared(self.origin, players[i].origin) < 150 * 150)
				{
					self playsound( "zmb_quad_close" );	
					wait randomfloatrange( 1, 2 );		
				}
			}
		}
		wait_network_frame();
	}
}
set_leap_attack_properties()
{
	self.pathEnemyFightDist = 320;
	self.goalradius = 320;
	self.maxsightdistsqrd = 256 * 256;
	self.can_leap = true;
}
set_default_attack_properties()
{
	self.pathEnemyFightDist = 64;
	self.meleeAttackDist = 64;
	self.goalradius = 16;
	self.maxsightdistsqrd = 128 * 128;
	self.can_leap = false;
}
check_wait()
{
	min_dist = 96;
	max_dist = 144;
	height_tolerance = 32;
	if ( isdefined( self.enemy ) )
	{
		delta = self.enemy.origin - self.origin;
		dist = length( delta );
		
		z_check = true;
		z_diff = abs( self.enemy.origin[2] - self.origin[2] );
		if ( z_diff > height_tolerance )
		{
			z_check = false;
		}
		if ( dist > min_dist && dist < max_dist && self.nextSpecial < GetTime() && z_check )	
		{
			cansee = SightTracePassed( self.origin, self.enemy.origin, false, undefined );
			if( cansee )
				self set_leap_attack_properties();
			else
				self set_default_attack_properties();
		}
		else
		{
			self set_default_attack_properties();
		}
	}
}
quad_zombie_think()
{
	self endon( "death" );
	
	self.specialAttack = maps\_zombiemode_ai_quad::TryLeap;
	self.state = "waiting";
	self.isAttacking = false;
	self.nextSpecial = GetTime();
	for (;;)
	{
		switch ( self.state )
		{
		case "waiting":
			check_wait();
			break;
		case "leaping":
			break;
		}
		wait_network_frame();
	}
	
}
trackCollision()
{
	self endon( "death" );
	self endon( "stop_coll" );
	while ( 1 )
	{
		check = self GetHitEntType();
		if ( check != "none" )
		{
			
			self thread quad_stop_leap();
			self notify( "stop_leap" );
			self notify( "stop_coll" );
		}
		wait_network_frame();
	}
}
quad_finish_leap()
{
	self endon( "death" );
	
	self.state = "waiting";
	self.isAttacking = false;
	self.nextSpecial = GetTime() + 3000;
	self animMode("none");
	self.syncedMeleeTarget = undefined;
	self OrientMode("face enemy");
	self thread animscripts\zombie_combat::main();
	
}
quad_stop_leap()
{
	self endon( "death" );
	self SetFlaggedAnimKnobAllRestart("attack",%ai_zombie_quad_attack_leap_loop_out, %body, 1, .1, 1);
	self animscripts\zombie_shared::DoNoteTracks( "attack" );
	self quad_finish_leap();
}
quad_leap_attack()
{
	self endon( "death" );
	self endon( "stop_leap" );
	
	
	self.state = "leaping";
	self.isAttacking = true;
	if( IsDefined( self.enemy ) )
	{
		self.syncedMeleeTarget = self.enemy;
		angles = VectorToAngles( self.enemy.origin - self.origin );
		self OrientMode( "face angle", angles[1] );
	}
	
	self set_default_attack_properties();
	self.goalradius = 4;
	self animMode("nogravity");
	leap_in = %ai_zombie_quad_attack_leap_loop_in;
	delta = GetMoveDelta( leap_in, 0, 1 );
	self SetFlaggedAnimKnobAllRestart("attack",%ai_zombie_quad_attack_leap_loop_in, %body, 1, .1, 1);
	animscripts\traverse\zombie_shared::wait_anim_length(leap_in, .02);
	use_loop = false;
	if ( use_loop )
	{
		leap_loop = %ai_zombie_quad_attack_leap_loop;
		self thread trackCollision();
		self SetFlaggedAnimKnobAllRestart("attack",leap_loop, %body, 1, .1, 1);
		delta = GetMoveDelta( leap_loop, 0, 1 );
		anim_dist = length( delta );
		anim_time = getanimlength( leap_loop );
		rate = anim_dist / getanimlength( leap_loop );
		goal_dist = length( self.enemy.origin - self.origin );
		goal_dist -= 16;	
		
		
		
		
		
		animscripts\traverse\zombie_shared::wait_anim_length(leap_loop, .02);
	
	}
	self notify( "stop_coll" );
	leap_out = %ai_zombie_quad_attack_leap_attack;
	if ( isdefined(self.enemy) )
	{
		delta = self.enemy.origin - self.origin;
		deltaF = ( delta[0], delta[1], 0 );
		attack_dist = length( deltaF );
		
		if ( attack_dist <= 64 )
		{
			leap_out = %ai_zombie_quad_attack_leap_attack;
		}
	}
	delta = GetMoveDelta( leap_out, 0, 1 );
	self SetFlaggedAnimKnobAllRestart("attack",leap_out, %body, 1, .1, 1);
	while ( 1 )
	{
		self waittill("attack", note);
		if ( note == "end" )
		{
			break;
		}
		else if ( note == "fire" )
		{
			if ( !IsDefined( self.enemy ) )
			{
				break;
			}
				
			oldhealth = self.enemy.health;
			self melee();
		}
		else if ( note == "gravity on" )
		{
			self animMode("none");
		}
	}
	
	quad_finish_leap();
	
}
TryLeap()
{
	
	if ( self.state == "leaping" )
	{
		return true;
	}
	if ( !IsDefined( self.enemy ) )
	{
		return false;
	}
	
	if ( DistanceSquared( self.origin, self.enemy.origin ) > 512*512 )
	{
		animscripts\zombie_melee::debug_melee( "Not doing melee - Distance to enemy is more than 512 units." );
		return false;
	}
	if ( self.a.pose == "prone" )
	{
		return false;
	}
	if ( !self.can_leap )
	{
		return false;
	}
	self thread maps\_zombiemode_ai_quad::quad_leap_attack();
	self notify( "special_attack" );
	return true;
}
quad_thundergun_disintegrate( player )
{
	self endon( "death" );
	self DoDamage( self.health + 666, player.origin, player );
}
quad_thundergun_knockdown( player, gib )
{
	self endon( "death" );
	damage = int( self.maxhealth * 0.5 );
	self DoDamage( damage, player.origin, player );
}
quad_gas_explo_death()
{   
    death_vars = [];
    death_vars["explo_radius_zomb"]     = self.death_explo_radius_zomb;
    death_vars["explo_radius_plr"]      = self.death_explo_radius_plr;
    death_vars["explo_damage_zomb"]     = self.death_explo_damage_zomb;
    death_vars["gas_radius"]            = self.death_gas_radius;
    death_vars["gas_time"]              = self.death_gas_time;
	
	self thread quad_death_explo( self.origin, death_vars );
	level thread quad_gas_area_of_effect( self.origin, death_vars );
	self Delete();
}
quad_death_explo( origin, death_vars )
{
    playsoundatposition( "zmb_quad_explo", origin );
    PlayFx( level._effect["dog_gib"], origin );
    
    players = get_players();
    zombies = GetAIArray( "axis" );
	
    for(i = 0; i < players.size; i++)
    {
        if( Distance( origin, players[i].origin ) <= death_vars["explo_radius_plr"] )
        {
            players[i] ShellShock( "explosion", 2.5 );
        }
    }
	self.exploded = true;
	self RadiusDamage( origin, death_vars["explo_radius_zomb"], level.zombie_health, level.zombie_health, self, "MOD_EXPLOSIVE" ); 
    
}
quad_damage_func( player )
{
	if ( self.exploded )
	{
		
		return 0;
	}
	return self.meleeDamage;
}
quad_gas_area_of_effect( origin, death_vars )
{
		effectArea = spawn( "trigger_radius", origin, 0, death_vars["gas_radius"], 100 );
		
		
		
		PlayFX( level._effect[ "quad_explo_gas" ], origin );
		
		gas_time = 0;
    
		while( gas_time <= death_vars["gas_time"] )
		{
			players = get_players();
			
			for(i = 0; i < players.size; i++)
			{
				if( players[i] IsTouching( effectArea ))
				{
					
					players[i] setblur( 4, .1 );
				}
				else
				{
					players[i] setblur( 0, .5 );
				}
			}
			
			wait(1);
			gas_time = gas_time + 1;
		}
		players = get_players();
		for ( i = 0; i < players.size; i++ )
		{
			players[i] setblur( 0, .5 );
		}
		
		
		effectArea Delete();
		
		
}
quad_trail()
{
	self endon( "death" );
	self waittill( "quad_end_traverse_anim" );
	
	self.fx_quad_trail = Spawn( "script_model", self GetTagOrigin( "tag_origin" ) );
	self.fx_quad_trail.angles = self GetTagAngles( "tag_origin" );
	self.fx_quad_trail SetModel( "tag_origin" );
	self.fx_quad_trail LinkTo( self, "tag_origin" );
	maps\_zombiemode_net::network_safe_play_fx_on_tag( "quad_fx", 2, level._effect[ "quad_trail" ], self.fx_quad_trail, "tag_origin" );
}
quad_post_death()
{
	if ( isdefined( self.fx_quad_trail ) )
	{
		self.fx_quad_trail unlink();
		self.fx_quad_trail delete();
	}
	if ( self.can_explode )
	{
		self thread quad_gas_explo_death();
	}
}
quad_killed_override( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime )
{
	if ( sMeansOfDeath == "MOD_PISTOL_BULLET" || sMeansOfDeath == "MOD_RIFLE_BULLET" )
	{
		self.can_explode = true;
	}
	else
	{
		self.can_explode = false;
		if ( isdefined( self.fx_quad_trail ) )
		{
			self.fx_quad_trail unlink();
			self.fx_quad_trail delete();
		}
	}
}
quad_pre_teleport()
{
	if ( isDefined( self.fx_quad_trail ) )
	{
		self.fx_quad_trail unlink();
		self.fx_quad_trail delete();
		wait( .1 );
	}
}
quad_post_teleport()
{
	if ( isDefined( self.fx_quad_trail ) )
	{
		self.fx_quad_trail unlink();
		self.fx_quad_trail delete();
	}
	if ( self.health > 0 )
	{
		self.fx_quad_trail = Spawn( "script_model", self GetTagOrigin( "tag_origin" ) );
		self.fx_quad_trail.angles = self GetTagAngles( "tag_origin" );
		self.fx_quad_trail SetModel( "tag_origin" );
		self.fx_quad_trail LinkTo( self, "tag_origin" );
		maps\_zombiemode_net::network_safe_play_fx_on_tag( "quad_fx", 2, level._effect[ "quad_trail" ], self.fx_quad_trail, "tag_origin" );
	}
}