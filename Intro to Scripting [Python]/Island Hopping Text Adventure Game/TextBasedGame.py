# Novasak, Ivan (2386349)
# 2022 August
# IT 140
# Project 2: Island Hopping Text Adventure Game


# Print main menu and commands
print('Island Hopping: A Text Adventure Game')
print('Collect all 7 supplies or be captured by the Sargasso Octopus Monster!')
print('Sail directions: north, south, east, west')
print('To add to your inventory, enter: get <item name>.')
print('The item names are spring water, fruits & veggies, first aid kit, extra sails, cutlery, spears, and meat')
print('To quit the game at any time, type quit.')


# Islands dictionary showing name of islands, possible directions, and item on the island
islands = {

    'Luana Retreat': {'name': 'Luana Retreat', 'west': 'Wildflower Springs', 'east': 'Lost Lily Island',
                      'north': 'Lusca Isles'},
    'Wildflower Springs': {'name': 'Wildflower Springs', 'east': 'Luana Retreat', 'item': 'spring water'},
    'Lost Lily Island': {'name': 'Lost Lily Island', 'west': 'Luana Retreat', 'item': 'fruits & veggies'},
    'Lusca Isles': {'name': 'Lusca Isles', 'north': 'Suna Haven', 'south': 'Luana Retreat', 'item': 'first aid kit'},
    'Suna Haven': {'name': 'Suna Haven', 'north': 'Avalon', 'south': 'Lusca Isles', 'east': 'Arcadia Rock',
                   'west': 'Electra Springs', 'item': 'extra sails'},
    'Avalon': {'name': 'Avalon', 'north': 'Asbury', 'south': 'Suna Haven', 'item': 'cutlery'},
    'Electra Springs': {'name': 'Electra Springs', 'east': 'Suna Haven', 'item': 'spears'},
    'Arcadia Rock': {'name': 'Arcadia Rock', 'west': 'Suna Haven', 'item': 'sargasso octopus monster'},
    'Asbury': {'name': 'Asbury', 'south': 'Avalon', 'item': 'meat'}

    }


# Directions list
directions = ['north', 'south', 'east', 'west']

# Create inventory
inventory = []

# Start the player at Luana Retreat
current_island = islands['Luana Retreat']


# Loop forever
while True:
    # display current location
    print('You are at {}.'.format(current_island['name']))

    # get the user's input decision
    userDecisionEntry = input('\nWhere do you want to sail? Valid directions are north, south, east, and west.\n'
                              'You can also write an item name to take it. ')
    decision = (userDecisionEntry.lower())
    # sail / get
    if decision in directions:
        if decision in current_island:
            current_island = islands[current_island[decision]]
        else:
            # bad movement
            print('You cannot sail that way.\n')
    if decision not in inventory:
        if decision in current_island:
            inventory = inventory.append(islands[current_island[decision]])
        else:
            # bad decision
            print('No item to get.\n')
    # quit game
    elif decision == 'quit':
        print('Thanks for playing Island Hopping!')
        break
    # bad command
    else:
        print('Invalid decision input')
