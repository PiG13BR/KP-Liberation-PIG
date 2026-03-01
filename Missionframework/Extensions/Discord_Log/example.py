import discord
from discord.ext
import json
import os
import asyncio
from datetime import datetime

# --- CONFIGURATION ---
TOKEN = 'token_here'
RPT_PATH = "path_to_log"
CHANNEL_ID_FACTORY = None # change later to use your channel ID
CHANNEL_FACTORY_MESSAGE = None  # After sending the first message, change here manualy to always edit the message
# just as a heads up, there are a few  "image_url" these are just place holders, change them later to have images on your embed
intents = discord.Intents.default()

def parse_rpt():
    if not os.path.exists(RPT_PATH):
        return None

    try:
        all_blocks = []
        current_block = []
        is_capturing = False

        with open(RPT_PATH, 'r', encoding='utf-8', errors='ignore') as file:
            for line in file:
                if "--- FACTORY_DATA_START ---" in line:
                    is_capturing = True
                    current_block = []
                    continue
                
                if "--- FACTORY_DATA_END ---" in line:
                    if is_capturing and current_block:
                        all_blocks.append(list(current_block))
                    is_capturing = False
                    continue

                if is_capturing and "[FACTORY_JSON]" in line:
                    current_block.append(line.strip())

        if not all_blocks:
            return None

        latest_raw_lines = all_blocks[-1]
        parsed_factories = []

        for line in latest_raw_lines:
            try:
                json_part = line.split('[FACTORY_JSON]')[1].strip()
                
                if json_part.startswith('"'):
                    json_part = json_part[1:]
                if json_part.endswith('"'):
                    json_part = json_part[:-1]
                
                clean_json = json_part.replace('""', '"')
                data = json.loads(clean_json)
                parsed_factories.append(data)
            except:
                continue

        return parsed_factories if parsed_factories else None

    except Exception as e:
        print(f"Error parsing RPT: {e}")
        return None

async def update_factory_status():
    global CHANNEL_FACTORY_MESSAGE
    await bot.wait_until_ready()
    
    channel = bot.get_channel(CHANNEL_ID_FACTORY)
    if not channel:
        print(f"Error: Channel {CHANNEL_ID_FACTORY} not found.")
        return

    while not bot.is_closed():
        try:
            data = parse_rpt()
            
            if data:
                groups = {"Ammo": [], "Supply": [], "Fuel": []}
                
                for entry in data:
                    p_type = entry.get('production_type', 'N/A')
                    if p_type in ["A", "Ammo"]: category = "Ammo"
                    elif p_type in ["S", "Supply"]: category = "Supply"
                    elif p_type in ["F", "Fuel"]: category = "Fuel"
                    else: category = None
                    
                    if category:
                        groups[category].append(entry)

                factories_list = []
                productions_list = []
                resources_list = []

                for category in ["Ammo", "Supply", "Fuel"]:
                    for entry in groups[category]:
                        factories_list.append(entry.get('name', 'Unknown'))
                        productions_list.append(category)
                        
                        s = entry.get('storage', {})
                        total = sum([s.get('supply', 0), s.get('ammo', 0), s.get('fuel', 0)])
                        resources_list.append(str(total))

                factory_val = "\n".join(factories_list) if factories_list else "None"
                prod_val = "\n".join(productions_list) if productions_list else "None"
                res_val = "\n".join(resources_list) if resources_list else "None"
                footer_text = f"Liberation Update • {len(data)} Factories Active"
            else:
                factory_val = "Waiting..."
                prod_val = "Waiting..."
                res_val = "Waiting..."
                footer_text = "Searching logs for factory data..."

            embed = discord.Embed(
                title="Factory Status",
                color=0x00b0f4,
                timestamp=datetime.now()
            )
            embed.set_author(
                name="OAB Factories",
                icon_url="image_url"
            )
            
            embed.add_field(name="🏭 Factory", value=factory_val, inline=True)
            embed.add_field(name="📦 Production", value=prod_val, inline=True)
            embed.add_field(name="📊 Total Storage", value=res_val, inline=True)
            
            embed.set_image(url="image_url")
            embed.set_footer(text=footer_text, icon_url="image_url")

            sent = False
            if CHANNEL_FACTORY_MESSAGE:
                try:
                    msg = await channel.fetch_message(CHANNEL_FACTORY_MESSAGE)
                    await msg.edit(embed=embed)
                    sent = True
                except (discord.NotFound, discord.HTTPException):
                    sent = False

            if not sent:
                new_msg = await channel.send(embed=embed)
                CHANNEL_FACTORY_MESSAGE = new_msg.id
                
        except Exception as e:
            print(f"Error in loop: {e}")

        await asyncio.sleep(30)

@bot.event
async def on_ready():
    print(f'Logged in as {bot.user.name}')
    bot.loop.create_task(update_factory_status())

if __name__ == "__main__":
    bot.run(TOKEN)