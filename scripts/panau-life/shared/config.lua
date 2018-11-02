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
    	default_items = "banane*25/eau*25",
    	default_level = 1,
    	default_xp = 0,
    	default_skills = "Collector$Speed*1$Quantity*1/Delivery$FuelConsumption*1$TrunkCapacity*1",
    	default_options = "WorldText*true",
    	default_skillspoint = 0
  	},
    UsableItems = {
        ["banane"] = {
            Type = "food",
            HungerValue = 0.2,
            ThirstValue = -0.005,
            SellPrice = 1.52
        },
        ["grosse banane"] = {
            Type = "food",
            HungerValue = 0.5,
            ThirstValue = -0.005,
            SellPrice = 5.4
        },
        ["eau"] = {
            Type = "food",
            HungerValue = 0.0,
            ThirstValue = 0.25,
            SellPrice = 0.7
        }
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
    CarDealer_Items = {
        ["Opel"] = {
            ["Chevalier Liner SB"] = {
                Model = 23,
                Prix = 22000
            },
            ["Sakura Aquila City"] = {
                Model = 29,
                Prix = 15000
            }
        },
        ["SakuraM"] = {
            ["Sakura Aquila Space"] = {
                Model = 15,
                Prix = 1200
            },
            ["Sakura Aquila Metro ST"] = {
                Model = 55,
                Prix = 1200
            },
            ["Sakura Aquila Forte"] = {
                Model = 70,
                Prix = 1200
            },
            ["Sakura Aquila City"] = {
                Model = 29,
                Prix = 15000
            }
        }
    },
    Cloth_Items = {
        ["WhatSaps"] = {
            ["City Male 1"] = {
                Model = 7,
                Prix = 95
            },
            ["City Female"] = {
                Model = 92,
                Prix = 95
            },
            ["Chinese Bodyguard"] = {
                Model = 6,
                Prix = 95
            },
            ["Exclusive Guest Variant 2"] = {
                Model = 95,
                Prix = 95
            },
            ["City Male 2"] = {
                Model = 35,
                Prix = 55
            },
            ["Politician"] = {
                Model = 36,
                Prix = 55
            }
        }
    },
    Garage_Items = {
        ["Jackie Tuning"] = {
            ["Dark Red"] = {
                Color1 = {r = 220,g = 10,b = 10},
                Color2 = {r = 20,g = 20,b = 20},
                Prix = 75
            },
            ["Dark Blue"] = {
                Color1 = {r = 10,g = 10,b = 220},
                Color2 = {r = 20,g = 20,b = 20},
                Prix = 75
            },
            ["Light Green"] = {
                Color1 = {r = 10,g = 220,b = 10},
                Color2 = {r = 150,g = 150,b = 150},
                Prix = 122
            }
        }
    },
    Champs_Items = {
        ["Bananes"] = {
            Time = 5.0,
            Items = {
                ["banane"] = {
                    Chance = 0.8
                },
                ["grosse banane"] = {
                    Chance = 0.2
                }
            }
        }
    },
    Restaurant_Items = {
        ["Burger King"]  = {
            ["Steak house"] = {
                Description = "Un putains de burger",
                Prix = 3.95,
                HungerValue = 0.25,
                ThirstValue = -0.05
            },
            ["Fanta Orange"] = {
                Description = "50cl de plaisirs",
                Prix = 1.95,
                HungerValue = 0,
                ThirstValue = 0.15
            }
        },
        ["Arbol"]  = {
            ["Galette de patate"] = {
                Description = "Un putains de galette",
                Prix = 6.95,
                HungerValue = 0.7,
                ThirstValue = -0.05
            },
            ["Bière sympas"] = {
                Description = "550cl de plaisirs",
                Prix = 1.95,
                HungerValue = 0,
                ThirstValue = 0.8
            }
        }
    }
}
