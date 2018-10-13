PanauLife = {}

PanauGUI = {}

PanauLife.Config = {
	User = {
    	default_x = 852.224,
    	default_y = 203.745,
    	default_z = 455.817,
    	default_angle = 90,
    	default_cash = 500,
    	default_account = 20000,
    	default_model = 7,
    	default_hunger = 1,
    	default_thirst = 1,
    	default_items = "banane*1/eau*2",
    	default_level = 1,
    	default_xp = 0,
    	default_skills = "Collector$Speed*1$Quantity*1/Delivery$FuelConsumption*1$TrunkCapacity*1",
    	default_options = "WorldText*true",
    	default_skillspoint = 0
  	},
	Level = {
  		default_xp = 500,
  		defaukt_multiplier = 1.1
	},
	SkillsCosts = {
		Collector = {
			Speed = 0.1,
			Quantity = 0.1
		}
	},
    Restaurant = {
        {
            DispName = "Raviollis aux poulet",
            Description = "6 pièces de raviolis aux poulet",
            Prix = 8,
            HungerValue = 0.15,
            ThirstValue = 0
        },
        {
            DispName = "Riz nature",
            Description = "Petit bol de riz nature",
            Prix = 2,
            HungerValue = 0.1,
            ThirstValue = -0.02
        },
        {
            DispName = "Perles de coco",
            Description = "2 perles de coco",
            Prix = 3,
            HungerValue = 0.05,
            ThirstValue = -0.2
        },
        {
            DispName = "Jus de mangue",
            Description = "25cl de jus de mangue",
            Prix = 3,
            HungerValue = -0.02,
            ThirstValue = 0.08
        }
    }
}
