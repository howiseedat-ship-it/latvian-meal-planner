#!/usr/bin/env python3
"""Generate recipes JSON for Latvian Meal Planner app."""

import json
import uuid
from pathlib import Path

def make_ingredient(name, qty, unit, optional=False):
    return {
        "id": str(uuid.uuid4()),
        "ingredientName": name,
        "quantity": qty,
        "unit": unit,
        "isOptional": optional
    }

def make_recipe(name, name_lv, desc, cuisine, ingredients, steps, prep, cook, servings,
                cal, prot, carbs, fats, tags=None, difficulty="easy", equipment=None):
    return {
        "id": str(uuid.uuid4()),
        "name": name,
        "nameLV": name_lv,
        "description": desc,
        "ingredients": ingredients,
        "steps": steps,
        "prepTimeMinutes": prep,
        "cookTimeMinutes": cook,
        "servings": servings,
        "caloriesPerServing": cal,
        "proteinPerServing": prot,
        "carbsPerServing": carbs,
        "fatsPerServing": fats,
        "dietaryTags": tags or [],
        "cuisine": cuisine,
        "difficulty": difficulty,
        "equipment": equipment or ["pan", "knife", "cutting-board"],
        "imageUrl": None
    }

RECIPES = []

# === LATVIAN TRADITIONAL ===
RECIPES.append(make_recipe(
    "Latvian Rye Bread", "Latvijas rudzu maize",
    "Traditional dense Latvian rye bread with caraway seeds.",
    "Latvian",
    [make_ingredient("rye flour", 500, "g"), make_ingredient("sourdough starter", 200, "g"),
     make_ingredient("water", 400, "ml"), make_ingredient("salt", 10, "g"),
     make_ingredient("caraway seeds", 15, "g", True)],
    ["Mix rye flour, sourdough starter, and water.", "Add salt and caraway, knead 10 min.",
     "Cover and let rise 8-12 hours.", "Shape into loaf, bake at 220C for 15 min.",
     "Reduce to 180C, bake 45 more minutes. Cool before slicing."],
    20, 60, 8, 180, 6, 35, 2, ["vegetarian", "vegan"], "medium",
    ["bread-machine", "mixing-bowl", "loaf-pan"]))

RECIPES.append(make_recipe(
    "Pierogi with Potato", "Pīrāgi ar kartupeļiem",
    "Latvian-style pierogi filled with mashed potato and onion.",
    "Latvian",
    [make_ingredient("flour", 300, "g"), make_ingredient("potatoes", 400, "g"),
     make_ingredient("onion", 1, "pcs"), make_ingredient("butter", 30, "g"),
     make_ingredient("egg", 1, "pcs"), make_ingredient("salt", 5, "g")],
    ["Boil and mash potatoes with butter and salt.", "Mix flour with egg and water to make dough.",
     "Roll dough thin, cut circles.", "Place potato filling in center, fold and seal edges.",
     "Boil pierogi in salted water for 5 minutes until they float."],
    30, 15, 4, 320, 8, 55, 8, ["vegetarian"], "medium",
    ["pot", "rolling-pin", "knife", "cutting-board"]))

RECIPES.append(make_recipe(
    "Sklandrausis Cake", "Sklandrausis",
    "Traditional Latvian layered cake with prune and cream filling.",
    "Latvian",
    [make_ingredient("rye flour", 200, "g"), make_ingredient("prunes", 200, "g"),
     make_ingredient("butter", 150, "g"), make_ingredient("sugar", 150, "g"),
     make_ingredient("cream", 200, "ml"), make_ingredient("cinnamon", 5, "g"),
     make_ingredient("eggs", 3, "pcs")],
    ["Soak prunes in warm water, chop finely.", "Mix rye flour with butter and sugar for base.",
     "Press base into a round cake pan.", "Spread prune filling over base.",
     "Whisk eggs with cream and cinnamon, pour over filling.",
     "Bake at 180C for 50 minutes until golden."],
    30, 50, 8, 380, 6, 52, 15, ["vegetarian"], "hard",
    ["oven", "mixing-bowl", "cake-pan", "whisk"]))

RECIPES.append(make_recipe(
    "Latvian Meatballs", "Gaļas bumbiņas",
    "Juicy Latvian meatballs in creamy tomato sauce.",
    "Latvian",
    [make_ingredient("ground beef", 400, "g"), make_ingredient("onion", 1, "pcs"),
     make_ingredient("bread crumbs", 50, "g"), make_ingredient("egg", 1, "pcs"),
     make_ingredient("tomato sauce", 300, "ml"), make_ingredient("cream", 100, "ml"),
     make_ingredient("salt", 5, "g"), make_ingredient("black pepper", 2, "g")],
    ["Mix ground beef with grated onion, breadcrumbs, egg, salt and pepper.",
     "Form into 2cm meatballs.", "Brown meatballs in a pan with oil.",
     "Add tomato sauce and cream, simmer for 20 minutes.",
     "Serve with mashed potatoes or rice."],
    20, 30, 4, 420, 30, 15, 25, [], "easy",
    ["pan", "mixing-bowl", "knife", "cutting-board"]))

# === QUICK MEALS ===
RECIPES.append(make_recipe(
    "Eggs Benedict", "Oliveru bēnediktins",
    "Classic eggs Benedict with hollandaise sauce.",
    "American",
    [make_ingredient("English muffins", 2, "pcs"), make_ingredient("eggs", 4, "pcs"),
     make_ingredient("bacon", 4, "slices"), make_ingredient("butter", 60, "g"),
     make_ingredient("lemon juice", 15, "ml"), make_ingredient("mustard", 5, "g")],
    ["Poach eggs in simmering water for 3 minutes.", "Fry bacon until crisp.",
     "Whisk butter with lemon juice and mustard for hollandaise.",
     "Split muffins, toast lightly.", "Assemble: muffin, bacon, egg, hollandaise."],
    15, 20, 2, 450, 22, 25, 30, [], "medium",
    ["saucepan", "pan", "knife"]))

RECIPES.append(make_recipe(
    "Greek Salad", "Grieķu salāti",
    "Fresh Mediterranean salad with feta cheese.",
    "Greek",
    [make_ingredient("cucumber", 1, "pcs"), make_ingredient("tomatoes", 3, "pcs"),
     make_ingredient("red onion", 0.5, "pcs"), make_ingredient("feta cheese", 150, "g"),
     make_ingredient("olives", 50, "g"), make_ingredient("olive oil", 30, "ml"),
     make_ingredient("oregano", 3, "g")],
    ["Chop cucumber, tomatoes, and onion.", "Arrange vegetables in a bowl.",
     "Crumble feta cheese over top.", "Add olives.",
     "Drizzle with olive oil and sprinkle oregano."],
    15, 0, 2, 280, 12, 8, 24, ["vegetarian"], "easy",
    ["knife", "cutting-board", "mixing-bowl"]))

RECIPES.append(make_recipe(
    "Pancakes", "Placītes",
    "Fluffy Latvian-style pancakes.",
    "Latvian",
    [make_ingredient("flour", 200, "g"), make_ingredient("milk", 300, "ml"),
     make_ingredient("eggs", 2, "pcs"), make_ingredient("sugar", 20, "g"),
     make_ingredient("butter", 30, "g"), make_ingredient("vanilla", 5, "ml")],
    ["Mix flour, sugar, eggs, and milk into smooth batter.",
     "Melt butter and let cool slightly, stir into batter.",
     "Heat a non-stick pan, pour small circles of batter.",
     "Cook until bubbles form, flip and cook other side.",
     "Serve with jam, honey, or sour cream."],
    10, 15, 4, 220, 6, 32, 9, ["vegetarian"], "easy",
    ["non-stick-pan", "mixing-bowl", "whisk"]))

# === HEALTHY / VEGAN ===
RECIPES.append(make_recipe(
    "Quinoa Bowl", "Kinu salātu bļoda",
    "Healthy quinoa bowl with roasted vegetables.",
    "Mediterranean",
    [make_ingredient("quinoa", 150, "g"), make_ingredient("bell pepper", 1, "pcs"),
     make_ingredient("zucchini", 1, "pcs"), make_ingredient("chickpeas", 150, "g"),
     make_ingredient("olive oil", 20, "ml"), make_ingredient("lemon", 0.5, "pcs"),
     make_ingredient("cumin", 3, "g"), make_ingredient("salt", 3, "g")],
    ["Cook quinoa according to package instructions.", "Dice vegetables, toss with oil and cumin.",
     "Roast vegetables at 200C for 20 minutes.", "Rinse chickpeas.",
     "Assemble bowl: quinoa base, roasted vegetables, chickpeas.",
     "Squeeze lemon over top and season with salt."],
    15, 30, 2, 380, 14, 52, 12, ["vegetarian", "vegan", "gluten-free"], "easy",
    ["oven", "baking-sheet", "pot", "knife", "cutting-board"]))

RECIPES.append(make_recipe(
    "Lentil Soup", "Lēcu zupa",
    "Hearty vegan lentil soup with vegetables.",
    "Mediterranean",
    [make_ingredient("red lentils", 200, "g"), make_ingredient("onion", 1, "pcs"),
     make_ingredient("carrot", 2, "pcs"), make_ingredient("celery", 1, "pcs"),
     make_ingredient("vegetable broth", 1000, "ml"), make_ingredient("cumin", 5, "g"),
     make_ingredient("turmeric", 3, "g"), make_ingredient("salt", 5, "g")],
    ["Chop onion, carrot, and celery.", "Sauté vegetables in a pot with oil for 5 minutes.",
     "Add lentils, broth, cumin, and turmeric.", "Simmer for 25 minutes until lentils are soft.",
     "Blend half the soup for a creamy texture.", "Season with salt and serve hot."],
    15, 30, 4, 280, 18, 42, 5, ["vegetarian", "vegan", "gluten-free"], "easy",
    ["pot", "knife", "cutting-board", "immersion-blender"]))

RECIPES.append(make_recipe(
    "Avocado Toast", "Avokado tost",
    "Simple avocado toast with poached egg.",
    "American",
    [make_ingredient("sourdough bread", 2, "slices"), make_ingredient("avocado", 1, "pcs"),
     make_ingredient("egg", 1, "pcs"), make_ingredient("lemon juice", 5, "ml"),
     make_ingredient("chili flakes", 1, "g"), make_ingredient("salt", 2, "g")],
    ["Toast the bread until golden.", "Mash avocado with lemon juice and salt.",
     "Spread avocado on toast.", "Poach egg for 3 minutes.",
     "Place egg on toast, sprinkle chili flakes."],
    5, 10, 1, 350, 14, 28, 20, ["vegetarian"], "easy",
    ["toaster-oven", "saucepan", "knife"]))

# === ASIAN ===
RECIPES.append(make_recipe(
    "Chicken Teriyaki", "Vistas teriyaki",
    "Japanese-style teriyaki chicken with rice.",
    "Japanese",
    [make_ingredient("chicken breast", 400, "g"), make_ingredient("soy sauce", 60, "ml"),
     make_ingredient("honey", 30, "ml"), make_ingredient("garlic", 3, "cloves"),
     make_ingredient("ginger", 10, "g"), make_ingredient("rice", 200, "g"),
     make_ingredient("sesame seeds", 5, "g")],
    ["Cook rice.", "Mix soy sauce, honey, garlic, and ginger for marinade.",
     "Marinate chicken for 30 minutes.", "Pan-fry chicken until golden and cooked through.",
     "Simmer remaining marinade until thickened, pour over chicken.",
     "Serve over rice, sprinkle sesame seeds."],
    20, 20, 2, 520, 42, 55, 12, [], "easy",
    ["rice-cooker", "pan", "knife", "cutting-board"]))

RECIPES.append(make_recipe(
    "Pad Thai", "Pad tai",
    "Thai stir-fried rice noodles with shrimp.",
    "Thai",
    [make_ingredient("rice noodles", 200, "g"), make_ingredient("shrimp", 200, "g"),
     make_ingredient("eggs", 2, "pcs"), make_ingredient("peanuts", 30, "g"),
     make_ingredient("soy sauce", 30, "ml"), make_ingredient("lime", 1, "pcs"),
     make_ingredient("bean sprouts", 100, "g"), make_ingredient("garlic", 2, "cloves")],
    ["Soak rice noodles in warm water for 20 minutes.", "Stir-fry shrimp with garlic for 2 minutes.",
     "Push shrimp aside, scramble eggs in the pan.", "Add noodles and soy sauce, toss well.",
     "Add bean sprouts, cook 1 minute.", "Serve with crushed peanuts and lime."],
    20, 15, 2, 480, 28, 60, 15, [], "medium",
    ["wok", "knife", "cutting-board"]))

RECIPES.append(make_recipe(
    "Veggie Spring Rolls", "Dārzeņu pavasara rullīši",
    "Crispy Vietnamese spring rolls with vegetables.",
    "Vietnamese",
    [make_ingredient("rice paper", 8, "sheets"), make_ingredient("carrot", 1, "pcs"),
     make_ingredient("cucumber", 1, "pcs"), make_ingredient("mint", 10, "leaves"),
     make_ingredient("vermicelli noodles", 100, "g"), make_ingredient("peanut sauce", 100, "ml")],
    ["Soak rice paper briefly in warm water until flexible.", "Cook vermicelli noodles.",
     "Julienne carrot and cucumber.", "Place noodles and vegetables on rice paper, roll tightly.",
     "Serve with peanut sauce for dipping."],
    20, 10, 2, 250, 6, 45, 6, ["vegetarian", "vegan"], "medium",
    ["knife", "cutting-board", "mixing-bowl"]))

# === SOUPS ===
RECIPES.append(make_recipe(
    "Tomato Soup", "Tomātu zupa",
    "Creamy tomato soup with basil.",
    "Italian",
    [make_ingredient("tomatoes", 6, "pcs"), make_ingredient("onion", 1, "pcs"),
     make_ingredient("garlic", 3, "cloves"), make_ingredient("vegetable broth", 500, "ml"),
     make_ingredient("cream", 100, "ml"), make_ingredient("basil", 10, "leaves"),
     make_ingredient("salt", 5, "g"), make_ingredient("olive oil", 20, "ml")],
    ["Sauté onion and garlic in olive oil.", "Add chopped tomatoes and broth, simmer 20 minutes.",
     "Blend until smooth.", "Stir in cream and basil.", "Season with salt and serve."],
    15, 25, 4, 180, 5, 22, 8, ["vegetarian"], "easy",
    ["pot", "immersion-blender", "knife", "cutting-board"]))

RECIPES.append(make_recipe(
    "Chicken Noodle Soup", "Vistas zupa ar makaroniem",
    "Classic comforting chicken noodle soup.",
    "American",
    [make_ingredient("chicken breast", 300, "g"), make_ingredient("noodles", 150, "g"),
     make_ingredient("carrot", 2, "pcs"), make_ingredient("celery", 2, "pcs"),
     make_ingredient("onion", 1, "pcs"), make_ingredient("chicken broth", 1000, "ml"),
     make_ingredient("salt", 5, "g"), make_ingredient("black pepper", 3, "g")],
    ["Boil chicken in broth for 20 minutes, remove and shred.",
     "Add chopped vegetables to broth, simmer 15 minutes.",
     "Add noodles and cook until tender.", "Return shredded chicken to soup.",
     "Season with salt and pepper, serve hot."],
    15, 40, 4, 280, 25, 35, 8, [], "easy",
    ["pot", "knife", "cutting-board"]))

# === BREAKFAST ===
RECIPES.append(make_recipe(
    "Oatmeal with Berries", "Auzu putras ar ogām",
    "Healthy oatmeal with fresh berries and honey.",
    "Scandinavian",
    [make_ingredient("oats", 80, "g"), make_ingredient("milk", 250, "ml"),
     make_ingredient("berries", 100, "g"), make_ingredient("honey", 15, "g"),
     make_ingredient("cinnamon", 2, "g"), make_ingredient("walnuts", 20, "g")],
    ["Cook oats with milk for 5 minutes.", "Stir in cinnamon.",
     "Top with fresh berries, honey, and walnuts."],
    5, 10, 1, 320, 10, 50, 8, ["vegetarian", "gluten-free"], "easy",
    ["saucepan"]))

RECIPES.append(make_recipe(
    "French Toast", "Franču tost",
    "Classic French toast with maple syrup.",
    "French",
    [make_ingredient("bread", 4, "slices"), make_ingredient("eggs", 3, "pcs"),
     make_ingredient("milk", 100, "ml"), make_ingredient("cinnamon", 3, "g"),
     make_ingredient("butter", 30, "g"), make_ingredient("maple syrup", 60, "ml")],
    ["Whisk eggs with milk and cinnamon.", "Dip bread slices in egg mixture.",
     "Fry in butter until golden on both sides.", "Serve with maple syrup."],
    10, 10, 2, 380, 12, 38, 18, ["vegetarian"], "easy",
    ["non-stick-pan", "mixing-bowl", "whisk"]))

# === DESSERTS ===
RECIPES.append(make_recipe(
    "Chocolate Cake", "Šokolādes kūka",
    "Moist chocolate layer cake with ganache.",
    "American",
    [make_ingredient("flour", 200, "g"), make_ingredient("cocoa powder", 60, "g"),
     make_ingredient("sugar", 200, "g"), make_ingredient("eggs", 3, "pcs"),
     make_ingredient("butter", 150, "g"), make_ingredient("milk", 200, "ml"),
     make_ingredient("chocolate", 150, "g")],
    ["Preheat oven to 180C.", "Mix dry ingredients: flour, cocoa, sugar.",
     "Melt butter, mix with eggs and milk.", "Combine wet and dry ingredients.",
     "Bake in a cake pan for 35 minutes.", "Melt chocolate with cream for ganache, pour over cooled cake."],
    20, 40, 8, 450, 6, 55, 25, ["vegetarian"], "medium",
    ["oven", "mixing-bowl", "whisk", "cake-pan"]))

RECIPES.append(make_recipe(
    "Apple Pie", "Ābolu kūka",
    "Classic apple pie with cinnamon filling.",
    "American",
    [make_ingredient("apples", 5, "pcs"), make_ingredient("flour", 300, "g"),
     make_ingredient("butter", 150, "g"), make_ingredient("sugar", 100, "g"),
     make_ingredient("cinnamon", 5, "g"), make_ingredient("eggs", 2, "pcs")],
    ["Peel and slice apples, toss with sugar and cinnamon.",
     "Make pastry dough from flour, butter, and egg.",
     "Line pie pan with half the dough.", "Add apple filling.",
     "Cover with remaining dough, seal edges.", "Bake at 190C for 45 minutes."],
    30, 45, 8, 320, 4, 45, 15, ["vegetarian"], "medium",
    ["oven", "pie-pan", "rolling-pin", "knife", "cutting-board"]))

# === SALADS ===
RECIPES.append(make_recipe(
    "Caesar Salad", "Cezāra salāti",
    "Classic Caesar salad with croutons and parmesan.",
    "Italian",
    [make_ingredient("romaine lettuce", 200, "g"), make_ingredient("chicken breast", 150, "g"),
     make_ingredient("parmesan", 50, "g"), make_ingredient("bread", 50, "g"),
     make_ingredient("mayonnaise", 30, "ml"), make_ingredient("garlic", 1, "clove"),
     make_ingredient("lemon juice", 10, "ml"), make_ingredient("olive oil", 20, "ml")],
    ["Grill chicken breast, slice into strips.", "Cut bread into cubes, fry until crisp.",
     "Mix mayonnaise, garlic, lemon juice, and olive oil for dressing.",
     "Tear lettuce into a bowl, add chicken and croutons.",
     "Drizzle with dressing, sprinkle parmesan."],
    15, 15, 2, 420, 30, 20, 25, [], "easy",
    ["grill", "pan", "knife", "cutting-board", "mixing-bowl"]))

# === SEAFOOD ===
RECIPES.append(make_recipe(
    "Grilled Salmon", "Grilēta lašzivs",
    "Grilled salmon with lemon butter sauce.",
    "Scandinavian",
    [make_ingredient("salmon fillet", 300, "g"), make_ingredient("butter", 30, "g"),
     make_ingredient("lemon", 1, "pcs"), make_ingredient("dill", 10, "g"),
     make_ingredient("salt", 3, "g"), make_ingredient("black pepper", 2, "g")],
    ["Season salmon with salt and pepper.", "Grill salmon skin-side down for 4 minutes.",
     "Flip and grill 3 more minutes.", "Melt butter with lemon juice and dill.",
     "Pour sauce over salmon and serve."],
    10, 10, 2, 380, 35, 2, 25, ["gluten-free"], "easy",
    ["grill", "knife"]))

# === MORE LATVIAN ===
RECIPES.append(make_recipe(
    "Cepelinai", "Cepelīni",
    "Latvian potato dumplings with meat filling.",
    "Latvian",
    [make_ingredient("potatoes", 1000, "g"), make_ingredient("ground pork", 300, "g"),
     make_ingredient("onion", 2, "pcs"), make_ingredient("bacon", 100, "g"),
     make_ingredient("sour cream", 200, "ml"), make_ingredient("salt", 8, "g"),
     make_ingredient("egg", 2, "pcs")],
    ["Boil and mash potatoes, mix with raw grated potato.",
     "Mix ground pork with chopped onion for filling.",
     "Form dumplings with meat filling inside.",
     "Boil in salted water for 25 minutes.",
     "Fry bacon until crisp, serve with sour cream and bacon."],
    40, 35, 4, 450, 22, 55, 18, [], "hard",
    ["pot", "pan", "knife", "cutting-board"]))

RECIPES.append(make_recipe(
    "Aitu Vārīti", "Aitu vārīti",
    "Traditional Latvian boiled sheep dish.",
    "Latvian",
    [make_ingredient("lamb", 800, "g"), make_ingredient("potatoes", 6, "pcs"),
     make_ingredient("carrot", 2, "pcs"), make_ingredient("onion", 2, "pcs"),
     make_ingredient("bay leaves", 3, "pcs"), make_ingredient("salt", 10, "g"),
     make_ingredient("black pepper", 5, "g")],
    ["Season lamb with salt and pepper.", "Boil lamb with bay leaves for 1 hour.",
     "Add chopped potatoes and carrots, cook 30 minutes.",
     "Add onions, cook 15 more minutes.", "Serve with mustard."],
    20, 105, 6, 380, 35, 30, 15, [], "medium",
    ["stockpot", "knife", "cutting-board"]))

RECIPES.append(make_recipe(
    "Rye Crackers", "Rudzu krekeri",
    "Crispy Latvian rye crackers with salt.",
    "Latvian",
    [make_ingredient("rye flour", 300, "g"), make_ingredient("water", 150, "ml"),
     make_ingredient("salt", 10, "g"), make_ingredient("caraway seeds", 10, "g"),
     make_ingredient("oil", 15, "ml")],
    ["Mix rye flour with water, salt, and oil.", "Knead into a firm dough.",
     "Roll very thin, cut into squares.", "Poke holes with a fork.",
     "Bake at 200C for 15 minutes until crisp."],
    20, 15, 6, 150, 5, 28, 2, ["vegetarian", "vegan"], "easy",
    ["oven", "baking-sheet", "rolling-pin"]))

RECIPES.append(make_recipe(
    "Latvian Herring Salad", "Silžu salāti",
    "Classic Latvian herring salad with potatoes.",
    "Latvian",
    [make_ingredient("pickled herring", 300, "g"), make_ingredient("potatoes", 4, "pcs"),
     make_ingredient("onion", 2, "pcs"), make_ingredient("carrot", 2, "pcs"),
     make_ingredient("vegetable oil", 40, "ml"), make_ingredient("salt", 3, "g")],
    ["Boil potatoes and carrots until tender, cool and dice.",
     "Cut herring into pieces, remove bones.",
     "Finely chop onions.", "Mix all ingredients with oil.",
     "Season with salt, chill before serving."],
    30, 20, 4, 280, 15, 25, 14, [], "easy",
    ["pot", "knife", "cutting-board", "mixing-bowl"]))

# === MEXICAN ===
RECIPES.append(make_recipe(
    "Tacos al Pastor", "Tacos al pastor",
    "Mexican marinated pork tacos with pineapple.",
    "Mexican",
    [make_ingredient("pork shoulder", 500, "g"), make_ingredient("tortillas", 8, "pcs"),
     make_ingredient("pineapple", 100, "g"), make_ingredient("onion", 1, "pcs"),
     make_ingredient("cilantro", 20, "g"), make_ingredient("chili powder", 10, "g"),
     make_ingredient("lime", 2, "pcs"), make_ingredient("cumin", 5, "g")],
    ["Marinate pork in chili, cumin, and lime for 2 hours.",
     "Grill pork until cooked through, slice thin.",
     "Char tortillas lightly.", "Dice onion and pineapple.",
     "Assemble tacos with pork, onion, pineapple, and cilantro."],
    30, 25, 4, 420, 30, 35, 15, [], "medium",
    ["grill", "pan", "knife", "cutting-board"]))

RECIPES.append(make_recipe(
    "Guacamole", "Gakamole",
    "Classic Mexican avocado dip.",
    "Mexican",
    [make_ingredient("avocado", 3, "pcs"), make_ingredient("lime", 2, "pcs"),
     make_ingredient("onion", 0.5, "pcs"), make_ingredient("tomato", 1, "pcs"),
     make_ingredient("cilantro", 15, "g"), make_ingredient("jalapeno", 1, "pcs"),
     make_ingredient("salt", 3, "g")],
    ["Mash avocados in a bowl.", "Finely chop onion, tomato, cilantro, and jalapeno.",
     "Mix all ingredients with lime juice.", "Season with salt."],
    10, 0, 4, 180, 2, 8, 16, ["vegetarian", "vegan", "gluten-free"], "easy",
    ["mixing-bowl", "knife", "cutting-board"]))

RECIPES.append(make_recipe(
    "Quesadillas", "Kezasillas",
    "Cheesy Mexican quesadillas with chicken.",
    "Mexican",
    [make_ingredient("flour tortillas", 6, "pcs"), make_ingredient("cheddar cheese", 200, "g"),
     make_ingredient("chicken breast", 200, "g"), make_ingredient("bell pepper", 1, "pcs"),
     make_ingredient("onion", 1, "pcs"), make_ingredient("cumin", 3, "g"),
     make_ingredient("butter", 20, "g")],
    ["Cook and shred chicken, season with cumin.", "Dice bell pepper and onion.",
     "Place cheese and fillings on half a tortilla, fold over.",
     "Fry in butter until golden and cheese melts."],
    15, 15, 3, 450, 28, 35, 22, [], "easy",
    ["pan", "knife", "cutting-board"]))

# === INDIAN ===
RECIPES.append(make_recipe(
    "Chicken Curry", "Vistas kari",
    "Indian-style chicken curry with coconut milk.",
    "Indian",
    [make_ingredient("chicken breast", 500, "g"), make_ingredient("coconut milk", 400, "ml"),
     make_ingredient("onion", 2, "pcs"), make_ingredient("garlic", 4, "cloves"),
     make_ingredient("ginger", 15, "g"), make_ingredient("curry powder", 15, "g"),
     make_ingredient("tomato", 2, "pcs"), make_ingredient("rice", 200, "g")],
    ["Cook rice.", "Sauté onion, garlic, and ginger.",
     "Add curry powder and tomatoes, cook 5 minutes.",
     "Add chicken and coconut milk, simmer 25 minutes.",
     "Serve over rice."],
    20, 35, 4, 520, 40, 55, 18, [], "medium",
    ["rice-cooker", "pot", "knife", "cutting-board"]))

RECIPES.append(make_recipe(
    "Palak Paneer", "Palak paneer",
    "Indian spinach curry with paneer cheese.",
    "Indian",
    [make_ingredient("spinach", 300, "g"), make_ingredient("paneer", 200, "g"),
     make_ingredient("onion", 1, "pcs"), make_ingredient("garlic", 3, "cloves"),
     make_ingredient("garam masala", 5, "g"), make_ingredient("cream", 50, "ml"),
     make_ingredient("tomato", 2, "pcs")],
    ["Blanch and blend spinach.", "Sauté onion and garlic.",
     "Add tomatoes and garam masala, cook 5 minutes.",
     "Add spinach puree and cream, simmer.",
     "Add cubed paneer, heat through."],
    20, 25, 3, 380, 18, 12, 28, ["vegetarian", "gluten-free"], "medium",
    ["pan", "blender", "knife", "cutting-board"]))

RECIPES.append(make_recipe(
    "Naan Bread", "Nāna maize",
    "Soft Indian flatbread.",
    "Indian",
    [make_ingredient("flour", 300, "g"), make_ingredient("yogurt", 100, "ml"),
     make_ingredient("yeast", 5, "g"), make_ingredient("sugar", 10, "g"),
     make_ingredient("butter", 30, "g"), make_ingredient("salt", 5, "g")],
    ["Mix flour, yeast, sugar, and salt.", "Add yogurt and knead dough.",
     "Let rise for 1 hour.", "Roll into flat circles.",
     "Bake at 250C for 5 minutes or grill on a hot pan."],
    20, 10, 4, 220, 7, 38, 5, ["vegetarian"], "medium",
    ["oven", "mixing-bowl", "rolling-pin"]))

# === MIDDLE EASTERN ===
RECIPES.append(make_recipe(
    "Hummus", "Hūmus",
    "Creamy Middle Eastern chickpea dip.",
    "Middle Eastern",
    [make_ingredient("chickpeas", 300, "g"), make_ingredient("tahini", 60, "ml"),
     make_ingredient("lemon juice", 30, "ml"), make_ingredient("garlic", 2, "cloves"),
     make_ingredient("olive oil", 30, "ml"), make_ingredient("cumin", 3, "g"),
     make_ingredient("salt", 3, "g")],
    ["Blend chickpeas with tahini, lemon juice, and garlic.",
     "Add olive oil and cumin, blend until smooth.",
     "Season with salt.", "Serve with pita bread."],
    10, 0, 4, 250, 8, 20, 16, ["vegetarian", "vegan", "gluten-free"], "easy",
    ["blender", "mixing-bowl"]))

RECIPES.append(make_recipe(
    "Falafel", "Falafeli",
    "Crispy Middle Eastern chickpea fritters.",
    "Middle Eastern",
    [make_ingredient("chickpeas", 300, "g"), make_ingredient("parsley", 30, "g"),
     make_ingredient("onion", 1, "pcs"), make_ingredient("garlic", 3, "cloves"),
     make_ingredient("cumin", 5, "g"), make_ingredient("coriander", 5, "g"),
     make_ingredient("flour", 50, "g"), make_ingredient("oil", 100, "ml")],
    ["Soak chickpeas overnight, drain.", "Blend with parsley, onion, garlic, and spices.",
     "Add flour, mix well.", "Form into balls.",
     "Fry in hot oil until golden brown."],
    30, 15, 4, 320, 14, 35, 15, ["vegetarian", "vegan"], "medium",
    ["blender", "deep-fryer", "knife", "cutting-board"]))

RECIPES.append(make_recipe(
    "Shakshuka", "Šakshuka",
    "North African eggs poached in tomato sauce.",
    "Middle Eastern",
    [make_ingredient("eggs", 4, "pcs"), make_ingredient("tomatoes", 4, "pcs"),
     make_ingredient("onion", 1, "pcs"), make_ingredient("bell pepper", 1, "pcs"),
     make_ingredient("cumin", 5, "g"), make_ingredient("paprika", 3, "g"),
     make_ingredient("feta cheese", 50, "g"), make_ingredient("olive oil", 20, "ml")],
    ["Sauté onion and bell pepper in olive oil.",
     "Add tomatoes, cumin, and paprika, simmer 15 minutes.",
     "Make wells in the sauce, crack eggs into them.",
     "Cover and cook until eggs are set.", "Top with feta."],
    15, 20, 2, 320, 18, 15, 20, ["vegetarian", "gluten-free"], "easy",
    ["pan", "knife", "cutting-board"]))

# === AFRICAN ===
RECIPES.append(make_recipe(
    "Jollof Rice", "Džolofa rīsi",
    "West African one-pot tomato rice.",
    "African",
    [make_ingredient("rice", 300, "g"), make_ingredient("tomatoes", 4, "pcs"),
     make_ingredient("onion", 2, "pcs"), make_ingredient("bell pepper", 1, "pcs"),
     make_ingredient("scotch bonnet", 1, "pcs"), make_ingredient("thyme", 3, "g"),
     make_ingredient("bay leaves", 2, "pcs"), make_ingredient("chicken broth", 500, "ml")],
    ["Blend tomatoes, onion, pepper, and scotch bonnet.",
     "Sauté the blend in a pot for 10 minutes.",
     "Add rice, broth, thyme, and bay leaves.",
     "Cover and simmer for 25 minutes until rice is tender."],
    20, 30, 4, 420, 8, 80, 6, ["vegetarian"], "medium",
    ["pot", "blender", "knife", "cutting-board"]))

RECIPES.append(make_recipe(
    "Tagine", "Tažīns",
    "Moroccan slow-cooked lamb tagine.",
    "African",
    [make_ingredient("lamb", 600, "g"), make_ingredient("onion", 2, "pcs"),
     make_ingredient("apricots", 100, "g"), make_ingredient("almonds", 50, "g"),
     make_ingredient("cinnamon", 3, "g"), make_ingredient("ginger", 10, "g"),
     make_ingredient("honey", 20, "ml"), make_ingredient("olive oil", 20, "ml")],
    ["Sear lamb in olive oil.", "Add chopped onions, cinnamon, and ginger.",
     "Add apricots and enough water to cover.",
     "Simmer covered for 1.5 hours until tender.",
     "Toast almonds, serve over tagine."],
    20, 95, 4, 450, 35, 25, 25, ["gluten-free"], "medium",
    ["tagine", "knife", "cutting-board"]))

# === FRENCH ===
RECIPES.append(make_recipe(
    "Coq au Vin", "Coq au vin",
    "Classic French chicken braised in red wine.",
    "French",
    [make_ingredient("chicken", 800, "g"), make_ingredient("red wine", 500, "ml"),
     make_ingredient("mushrooms", 200, "g"), make_ingredient("bacon", 100, "g"),
     make_ingredient("onion", 2, "pcs"), make_ingredient("carrot", 2, "pcs"),
     make_ingredient("garlic", 3, "cloves"), make_ingredient("beef broth", 300, "ml")],
    ["Sear chicken pieces and bacon.", "Add onions, carrots, and garlic.",
     "Pour in red wine and beef broth.", "Add mushrooms.",
     "Simmer covered for 1.5 hours until chicken is tender."],
    30, 95, 4, 520, 42, 15, 28, [], "hard",
    ["dutch-oven", "knife", "cutting-board"]))

RECIPES.append(make_recipe(
    "Ratatouille", "Ratatuj",
    "Provençal vegetable stew.",
    "French",
    [make_ingredient("zucchini", 2, "pcs"), make_ingredient("eggplant", 1, "pcs"),
     make_ingredient("bell pepper", 2, "pcs"), make_ingredient("tomatoes", 4, "pcs"),
     make_ingredient("onion", 1, "pcs"), make_ingredient("garlic", 3, "cloves"),
     make_ingredient("olive oil", 40, "ml"), make_ingredient("herbs de provence", 5, "g")],
    ["Dice all vegetables.", "Sauté onion and garlic in olive oil.",
     "Add vegetables in order: eggplant, zucchini, pepper, tomatoes.",
     "Add herbs, simmer for 45 minutes."],
    25, 45, 4, 180, 5, 22, 8, ["vegetarian", "vegan", "gluten-free"], "easy",
    ["pot", "knife", "cutting-board"]))

RECIPES.append(make_recipe(
    "Croissants", "Kruasani",
    "Buttery French croissants.",
    "French",
    [make_ingredient("flour", 500, "g"), make_ingredient("butter", 250, "g"),
     make_ingredient("milk", 200, "ml"), make_ingredient("yeast", 10, "g"),
     make_ingredient("sugar", 50, "g"), make_ingredient("salt", 5, "g")],
    ["Mix flour, yeast, milk, sugar, and salt into dough.",
     "Knead and let rest 30 minutes.", "Roll out, spread butter, fold in thirds.",
     "Repeat folding 3 times, chilling between.",
     "Shape into croissants, let rise 1 hour.", "Bake at 200C for 15 minutes."],
    60, 20, 8, 320, 6, 38, 16, ["vegetarian"], "hard",
    ["oven", "mixing-bowl", "rolling-pin"]))

# === SPANISH ===
RECIPES.append(make_recipe(
    "Paella", "Paelja",
    "Spanish saffron rice with chicken and seafood.",
    "Spanish",
    [make_ingredient("rice", 300, "g"), make_ingredient("chicken", 300, "g"),
     make_ingredient("shrimp", 200, "g"), make_ingredient("saffron", 1, "g"),
     make_ingredient("onion", 1, "pcs"), make_ingredient("bell pepper", 1, "pcs"),
     make_ingredient("chicken broth", 700, "ml"), make_ingredient("olive oil", 30, "ml")],
    ["Sear chicken in olive oil.", "Add onion and bell pepper, cook 5 minutes.",
     "Add rice and saffron, stir 2 minutes.",
     "Pour in broth, do not stir.", "Add shrimp on top.",
     "Cook 20 minutes until rice is tender."],
    20, 30, 4, 480, 35, 55, 12, [], "medium",
    ["paella-pan", "knife", "cutting-board"]))

RECIPES.append(make_recipe(
    "Gazpacho", "Gazpacho",
    "Cold Spanish tomato soup.",
    "Spanish",
    [make_ingredient("tomatoes", 6, "pcs"), make_ingredient("cucumber", 1, "pcs"),
     make_ingredient("bell pepper", 1, "pcs"), make_ingredient("onion", 0.5, "pcs"),
     make_ingredient("garlic", 2, "cloves"), make_ingredient("olive oil", 40, "ml"),
     make_ingredient("vinegar", 15, "ml"), make_ingredient("salt", 5, "g")],
    ["Blend all ingredients until smooth.", "Chill for 2 hours.",
     "Serve cold with croutons."],
    15, 0, 4, 120, 3, 12, 7, ["vegetarian", "vegan", "gluten-free"], "easy",
    ["blender"]))

# === GERMAN ===
RECIPES.append(make_recipe(
    "Sauerbraten", "Zauerbratens",
    "German pot roast marinated in wine vinegar.",
    "German",
    [make_ingredient("beef", 800, "g"), make_ingredient("red wine", 300, "ml"),
     make_ingredient("vinegar", 100, "ml"), make_ingredient("onion", 3, "pcs"),
     make_ingredient("carrot", 2, "pcs"), make_ingredient("bay leaves", 3, "pcs"),
     make_ingredient("mustard", 30, "g"), make_ingredient("beef broth", 300, "ml")],
    ["Marinate beef in wine, vinegar, and spices for 2 days.",
     "Remove beef, drain marinade.", "Brown beef in a pot.",
     "Add vegetables and marinade, simmer 2.5 hours.",
     "Thicken sauce with mustard."],
    30, 155, 4, 550, 45, 15, 32, [], "hard",
    ["dutch-oven", "knife", "cutting-board"]))

RECIPES.append(make_recipe(
    "Pork Schnitzel", "Cūkgaļas šnicelis",
    "Crispy breaded pork cutlet.",
    "German",
    [make_ingredient("pork tenderloin", 400, "g"), make_ingredient("flour", 100, "g"),
     make_ingredient("eggs", 3, "pcs"), make_ingredient("bread crumbs", 150, "g"),
     make_ingredient("butter", 50, "g"), make_ingredient("lemon", 2, "pcs"),
     make_ingredient("salt", 5, "g"), make_ingredient("black pepper", 3, "g")],
    ["Pound pork thin, season with salt and pepper.",
     "Dredge in flour, dip in beaten eggs, coat with breadcrumbs.",
     "Fry in butter until golden on both sides.",
     "Serve with lemon wedges."],
    20, 15, 2, 480, 35, 25, 28, [], "easy",
    ["pan", "mixing-bowl", "knife"]))

RECIPES.append(make_recipe(
    "German Potato Salad", "Vācu kartupeļu salāti",
    "Warm German potato salad with bacon.",
    "German",
    [make_ingredient("potatoes", 600, "g"), make_ingredient("bacon", 100, "g"),
     make_ingredient("onion", 2, "pcs"), make_ingredient("vinegar", 40, "ml"),
     make_ingredient("oil", 30, "ml"), make_ingredient("mustard", 15, "g"),
     make_ingredient("salt", 5, "g"), make_ingredient("pepper", 3, "g")],
    ["Boil potatoes until tender, slice.", "Fry bacon until crisp.",
     "Caramelize onions in bacon fat.",
     "Mix vinegar, oil, and mustard for dressing.",
     "Toss warm potatoes with bacon, onions, and dressing."],
    20, 30, 4, 320, 12, 35, 15, [], "medium",
    ["pot", "pan", "knife", "cutting-board"]))

# === ITALIAN (more) ===
RECIPES.append(make_recipe(
    "Lasagna", "Lasagna",
    "Classic Italian layered pasta bake.",
    "Italian",
    [make_ingredient("lasagna sheets", 250, "g"), make_ingredient("ground beef", 500, "g"),
     make_ingredient("tomato sauce", 500, "ml"), make_ingredient("ricotta", 300, "g"),
     make_ingredient("mozzarella", 200, "g"), make_ingredient("onion", 1, "pcs"),
     make_ingredient("parmesan", 50, "g"), make_ingredient("egg", 1, "pcs")],
    ["Brown ground beef with onion, add tomato sauce, simmer 20 minutes.",
     "Mix ricotta with egg and parmesan.",
     "Layer: sauce, pasta, ricotta, cheese. Repeat.",
     "Bake at 180C for 40 minutes."],
    30, 45, 6, 520, 35, 45, 25, [], "medium",
    ["oven", "glass-baking-dish", "pan", "knife", "cutting-board"]))

RECIPES.append(make_recipe(
    "Margherita Pizza", "Marģeritas pica",
    "Classic Neapolitan pizza.",
    "Italian",
    [make_ingredient("pizza dough", 300, "g"), make_ingredient("tomato sauce", 100, "ml"),
     make_ingredient("mozzarella", 150, "g"), make_ingredient("basil", 10, "leaves"),
     make_ingredient("olive oil", 15, "ml")],
    ["Preheat oven to 250C.", "Stretch dough into a circle.",
     "Spread tomato sauce, add mozzarella.",
     "Bake for 10-12 minutes until crust is golden.",
     "Top with basil and olive oil."],
    15, 12, 1, 380, 15, 45, 14, ["vegetarian"], "easy",
    ["oven", "pizza-stone", "rolling-pin"]))

RECIPES.append(make_recipe(
    "Risotto", "Risoto",
    "Creamy Italian mushroom risotto.",
    "Italian",
    [make_ingredient("arborio rice", 250, "g"), make_ingredient("mushrooms", 200, "g"),
     make_ingredient("onion", 1, "pcs"), make_ingredient("white wine", 100, "ml"),
     make_ingredient("chicken broth", 700, "ml"), make_ingredient("parmesan", 50, "g"),
     make_ingredient("butter", 30, "g"), make_ingredient("olive oil", 20, "ml")],
    ["Sauté onion and mushrooms in olive oil.",
     "Add rice, toast for 2 minutes.", "Pour in white wine, stir until absorbed.",
     "Add broth one ladle at a time, stirring constantly.",
     "When rice is creamy, stir in butter and parmesan."],
    15, 30, 3, 420, 12, 60, 12, ["vegetarian"], "medium",
    ["saucepan", "knife", "cutting-board"]))

# === MORE ASIAN ===
RECIPES.append(make_recipe(
    "Sushi Rolls", "Suši rullīši",
    "Japanese maki sushi rolls.",
    "Japanese",
    [make_ingredient("sushi rice", 300, "g"), make_ingredient("nori sheets", 4, "pcs"),
     make_ingredient("salmon", 150, "g"), make_ingredient("cucumber", 1, "pcs"),
     make_ingredient("avocado", 1, "pcs"), make_ingredient("soy sauce", 50, "ml"),
     make_ingredient("wasabi", 10, "g")],
    ["Cook sushi rice, season with vinegar.",
     "Place nori on a bamboo mat, spread rice thinly.",
     "Place salmon and cucumber in center, roll tightly.",
     "Cut into 6 pieces with a wet knife.", "Serve with soy sauce and wasabi."],
    30, 15, 2, 320, 12, 55, 6, [], "medium",
    ["knife", "bamboo-steamer"]))

RECIPES.append(make_recipe(
    "Kimchi Fried Rice", "Kimči rīsu vārījums",
    "Korean-style fried rice with kimchi.",
    "Korean",
    [make_ingredient("cooked rice", 300, "g"), make_ingredient("kimchi", 150, "g"),
     make_ingredient("eggs", 2, "pcs"), make_ingredient("onion", 1, "pcs"),
     make_ingredient("soy sauce", 20, "ml"), make_ingredient("sesame oil", 10, "ml"),
     make_ingredient("green onion", 2, "pcs")],
    ["Scramble eggs in a wok, set aside.", "Sauté onion and kimchi.",
     "Add rice and soy sauce, stir fry 5 minutes.",
     "Add eggs back, finish with sesame oil and green onion."],
    10, 15, 2, 380, 14, 55, 10, [], "easy",
    ["wok", "knife", "cutting-board"]))

RECIPES.append(make_recipe(
    "Pho", "Fo",
    "Vietnamese beef noodle soup.",
    "Vietnamese",
    [make_ingredient("beef bones", 500, "g"), make_ingredient("rice noodles", 200, "g"),
     make_ingredient("beef slices", 200, "g"), make_ingredient("onion", 1, "pcs"),
     make_ingredient("star anise", 3, "pcs"), make_ingredient("cinnamon", 1, "stick"),
     make_ingredient("fish sauce", 30, "ml"), make_ingredient("herbs", 30, "g")],
    ["Roast onion, simmer with beef bones and spices for 3 hours.",
     "Strain broth, season with fish sauce.",
     "Cook rice noodles.", "Place noodles in bowl, add raw beef slices.",
     "Pour hot broth over, top with herbs."],
    30, 185, 3, 420, 35, 55, 8, [], "hard",
    ["stockpot", "knife", "cutting-board"]))

# === AMERICAN (more) ===
RECIPES.append(make_recipe(
    "BBQ Ribs", "BBJ ribiņas",
    "American-style barbecue pork ribs.",
    "American",
    [make_ingredient("pork ribs", 1000, "g"), make_ingredient("bbq sauce", 200, "ml"),
     make_ingredient("brown sugar", 50, "g"), make_ingredient("paprika", 10, "g"),
     make_ingredient("garlic powder", 5, "g"), make_ingredient("salt", 10, "g"),
     make_ingredient("black pepper", 5, "g")],
    ["Mix brown sugar, paprika, garlic powder, salt, and pepper.",
     "Coat ribs with dry rub, marinate overnight.",
     "Wrap in foil, bake at 150C for 2 hours.",
     "Unwrap, brush with BBQ sauce, grill 10 minutes."],
    20, 130, 4, 580, 40, 35, 30, [], "medium",
    ["oven", "grill", "aluminum-foil"]))

RECIPES.append(make_recipe(
    "Cheeseburger", "Siera burgeris",
    "Classic American cheeseburger.",
    "American",
    [make_ingredient("ground beef", 200, "g"), make_ingredient("burger buns", 2, "pcs"),
     make_ingredient("cheddar cheese", 60, "g"), make_ingredient("lettuce", 30, "g"),
     make_ingredient("tomato", 1, "pcs"), make_ingredient("onion", 0.5, "pcs"),
     make_ingredient("ketchup", 30, "ml"), make_ingredient("mustard", 15, "ml")],
    ["Form beef into patties, season with salt and pepper.",
     "Grill patties for 3-4 minutes per side.",
     "Add cheese in last minute to melt.",
     "Toast buns, assemble with lettuce, tomato, onion, and sauces."],
    15, 10, 2, 550, 30, 40, 28, [], "easy",
    ["grill", "pan", "knife", "cutting-board"]))

RECIPES.append(make_recipe(
    "Mac and Cheese", "Makaroni ar sieru",
    "Creamy American macaroni and cheese.",
    "American",
    [make_ingredient("macaroni", 300, "g"), make_ingredient("cheddar cheese", 200, "g"),
     make_ingredient("milk", 300, "ml"), make_ingredient("butter", 40, "g"),
     make_ingredient("flour", 30, "g"), make_ingredient("mustard", 10, "g"),
     make_ingredient("bread crumbs", 50, "g")],
    ["Cook macaroni until al dente.", "Make a roux with butter and flour.",
     "Add milk, cook until thickened.", "Stir in cheese and mustard.",
     "Mix with pasta, top with breadcrumbs, bake at 180C for 15 minutes."],
    15, 25, 4, 520, 22, 55, 22, ["vegetarian"], "easy",
    ["oven", "pot", "saucepan", "glass-baking-dish"]))

# === HEALTHY / KETO ===
RECIPES.append(make_recipe(
    "Zucchini Noodles", "Cukīni makaroni",
    "Low-carb zucchini noodles with pesto.",
    "Mediterranean",
    [make_ingredient("zucchini", 3, "pcs"), make_ingredient("basil pesto", 100, "ml"),
     make_ingredient("cherry tomatoes", 100, "g"), make_ingredient("parmesan", 30, "g"),
     make_ingredient("olive oil", 15, "ml"), make_ingredient("salt", 2, "g")],
    ["Spiralize zucchini into noodles.", "Sauté zucchini noodles for 2 minutes.",
     "Toss with pesto and halved cherry tomatoes.",
     "Top with parmesan."],
    15, 5, 2, 220, 8, 10, 18, ["vegetarian", "gluten-free", "low-carb"], "easy",
    ["spiralizer", "pan", "knife"]))

RECIPES.append(make_recipe(
    "Stuffed Bell Peppers", "Pildīti papriku",
    "Low-carb bell peppers stuffed with ground meat.",
    "Mediterranean",
    [make_ingredient("bell peppers", 4, "pcs"), make_ingredient("ground beef", 400, "g"),
     make_ingredient("rice", 100, "g"), make_ingredient("tomato sauce", 200, "ml"),
     make_ingredient("onion", 1, "pcs"), make_ingredient("cheese", 100, "g"),
     make_ingredient("salt", 5, "g"), make_ingredient("pepper", 3, "g")],
    ["Cook rice.", "Brown ground beef with onion.",
     "Mix beef with rice and half the cheese.",
     "Fill peppers with mixture, top with tomato sauce and cheese.",
     "Bake at 180C for 35 minutes."],
    20, 40, 4, 380, 28, 30, 15, ["gluten-free"], "medium",
    ["oven", "baking-dish", "pan", "knife", "cutting-board"]))

RECIPES.append(make_recipe(
    "Salmon Avocado Bowl", "Laša avokado bļoda",
    "Healthy bowl with grilled salmon and avocado.",
    "Japanese",
    [make_ingredient("salmon fillet", 200, "g"), make_ingredient("avocado", 1, "pcs"),
     make_ingredient("rice", 150, "g"), make_ingredient("cucumber", 1, "pcs"),
     make_ingredient("soy sauce", 20, "ml"), make_ingredient("sesame seeds", 5, "g"),
     make_ingredient("lime", 0.5, "pcs")],
    ["Cook rice.", "Grill salmon until cooked through.",
     "Slice avocado and cucumber.",
     "Assemble bowl: rice, salmon, avocado, cucumber.",
     "Drizzle with soy sauce, sprinkle sesame seeds."],
    15, 15, 1, 450, 30, 45, 18, ["gluten-free"], "easy",
    ["grill", "rice-cooker", "knife", "cutting-board"]))

# === SOUPS (more) ===
RECIPES.append(make_recipe(
    "Mushroom Soup", "Sēņu zupa",
    "Creamy mushroom soup.",
    "European",
    [make_ingredient("mushrooms", 300, "g"), make_ingredient("onion", 1, "pcs"),
     make_ingredient("garlic", 2, "cloves"), make_ingredient("cream", 150, "ml"),
     make_ingredient("vegetable broth", 500, "ml"), make_ingredient("butter", 20, "g"),
     make_ingredient("thyme", 3, "g"), make_ingredient("salt", 5, "g")],
    ["Sauté mushrooms in butter until browned.",
     "Add onion and garlic, cook 3 minutes.",
     "Add broth and thyme, simmer 15 minutes.",
     "Blend until smooth, stir in cream.", "Season with salt."],
    15, 25, 4, 220, 6, 15, 15, ["vegetarian", "gluten-free"], "easy",
    ["pot", "immersion-blender", "knife", "cutting-board"]))

RECIPES.append(make_recipe(
    "Minestrone", "Minestrone",
    "Italian vegetable soup with beans and pasta.",
    "Italian",
    [make_ingredient("canned beans", 200, "g"), make_ingredient("carrot", 2, "pcs"),
     make_ingredient("celery", 2, "pcs"), make_ingredient("zucchini", 1, "pcs"),
     make_ingredient("tomatoes", 3, "pcs"), make_ingredient("pasta", 100, "g"),
     make_ingredient("onion", 1, "pcs"), make_ingredient("vegetable broth", 1000, "ml")],
    ["Sauté onion, carrot, and celery.",
     "Add tomatoes and broth, simmer 20 minutes.",
     "Add zucchini and beans, cook 10 minutes.",
     "Add pasta, cook until tender.", "Serve with parmesan."],
    20, 40, 4, 280, 12, 45, 6, ["vegetarian"], "easy",
    ["pot", "knife", "cutting-board"]))


# === MAIN OUTPUT ===
def main():
    output_path = Path(__file__).parent.parent / "Sources" / "Data" / "recipes.json"
    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(RECIPES, f, ensure_ascii=False, indent=2)
    print(f"Generated {len(RECIPES)} recipes -> {output_path}")

if __name__ == "__main__":
    main()
