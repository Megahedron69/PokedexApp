import 'dart:math';

/// Represents a Pokémon type with its characteristics
class PokemonType {
  final String name;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> immunities;

  const PokemonType({
    required this.name,
    required this.strengths,
    required this.weaknesses,
    this.immunities = const [],
  });
}

/// Represents a status condition that can affect a Pokémon
class StatusCondition {
  final String name;
  final int durationTurns;
  final double attackModifier;
  final double defenseModifier;
  final double speedModifier;
  final int damagePerTurn;
  final String description;

  const StatusCondition({
    required this.name,
    this.durationTurns = 3,
    this.attackModifier = 1.0,
    this.defenseModifier = 1.0,
    this.speedModifier = 1.0,
    this.damagePerTurn = 0,
    required this.description,
  });
}

/// Represents a move category (Physical, Special, or Status)
enum MoveCategory { physical, special, status }

/// Represents the priority of a move
enum MovePriority {
  veryLow(-2),
  low(-1),
  normal(0),
  high(1),
  veryHigh(2);

  final int value;
  const MovePriority(this.value);
}

/// Represents a move or attack a Pokémon can perform
class Move {
  final String name;
  final int power;
  final String type;
  final MoveCategory category;
  final MovePriority priority;
  final int accuracy;
  final int powerPoints;
  final StatusCondition? effect;
  final double effectChance;
  final String description;

  const Move({
    required this.name,
    required this.power,
    required this.type,
    this.category = MoveCategory.physical,
    this.priority = MovePriority.normal,
    this.accuracy = 100,
    this.powerPoints = 10,
    this.effect,
    this.effectChance = 0.0,
    this.description = '',
  });
}

/// Represents a Pokémon with detailed stats and abilities
class Pokemon {
  final String name;
  final int baseHp;
  final int attack;
  final int specialAttack;
  final int defense;
  final int specialDefense;
  final int speed;
  final List<String> types;
  final List<Move> moves;
  final String ability;

  int currentHp;
  int remainingPP = 100; // Stamina/energy system
  StatusCondition? status;
  int statusTurnsLeft = 0;

  // Stat modifiers (range from -6 to +6)
  Map<String, int> statModifiers = {
    'attack': 0,
    'specialAttack': 0,
    'defense': 0,
    'specialDefense': 0,
    'speed': 0,
    'accuracy': 0,
    'evasion': 0,
  };

  Pokemon({
    required this.name,
    required this.baseHp,
    required this.attack,
    required this.defense,
    required this.types,
    required this.moves,
    this.specialAttack = 0,
    this.specialDefense = 0,
    this.speed = 50,
    this.ability = 'None',
  }) : currentHp = baseHp;

  bool get isFainted => currentHp <= 0;

  // Get the actual stat value after applying modifiers
  int getModifiedStat(String stat) {
    int baseValue;
    switch (stat) {
      case 'attack':
        baseValue = attack;
        break;
      case 'specialAttack':
        baseValue = specialAttack;
        break;
      case 'defense':
        baseValue = defense;
        break;
      case 'specialDefense':
        baseValue = specialDefense;
        break;
      case 'speed':
        baseValue = speed;
        break;
      default:
        return 0;
    }

    // Apply status modifiers
    if (status != null) {
      if (stat == 'attack') {
        baseValue = (baseValue * status!.attackModifier).round();
      }
      if (stat == 'defense') {
        baseValue = (baseValue * status!.defenseModifier).round();
      }
      if (stat == 'speed') {
        baseValue = (baseValue * status!.speedModifier).round();
      }
    }

    // Apply stat modifiers
    int modifier = statModifiers[stat] ?? 0;
    double multiplier =
        (modifier >= 0) ? (2 + modifier) / 2 : 2 / (2 - modifier);

    return (baseValue * multiplier).round();
  }

  void applyStatModifier(String stat, int change) {
    if (statModifiers.containsKey(stat)) {
      statModifiers[stat] = max(
        -6,
        min(6, (statModifiers[stat] ?? 0) + change),
      );
    }
  }

  void applyStatus(StatusCondition newStatus) {
    status = newStatus;
    statusTurnsLeft = newStatus.durationTurns;
  }

  void clearStatus() {
    status = null;
    statusTurnsLeft = 0;
  }

  bool updateStatusCondition() {
    if (status == null) return false;

    statusTurnsLeft--;
    if (statusTurnsLeft <= 0) {
      clearStatus();
      return true;
    }
    return false;
  }

  String processStatusEffects() {
    if (status == null) return '';

    String result = '';
    if (status!.damagePerTurn > 0) {
      int damage = (baseHp * 0.0625).round();
      currentHp = max(1, currentHp - damage);
      result = "$name is hurt by ${status!.name}! (-$damage HP)";
    }

    bool cleared = updateStatusCondition();
    if (cleared) {
      result += "\n$name recovered from ${status!.name}!";
    }

    return result;
  }
}

/// Core battle engine handling turn-based logic, damage calculation, and type effectiveness
class PokemonBattleEngine {
  final Random _random = Random();
  int turnCounter = 0;
  bool battleEnded = false;
  final List<String> battleLog = [];

  String currentWeather = 'clear';
  int weatherTurnsLeft = 0;

  final Map<String, Map<String, double>> _typeEffectiveness = {
    'normal': {'rock': 0.5, 'steel': 0.5, 'ghost': 0.0},
    'fire': {
      'fire': 0.5,
      'water': 0.5,
      'grass': 2.0,
      'ice': 2.0,
      'bug': 2.0,
      'rock': 0.5,
      'dragon': 0.5,
      'steel': 2.0,
    },
    'water': {
      'fire': 2.0,
      'water': 0.5,
      'grass': 0.5,
      'ground': 2.0,
      'rock': 2.0,
      'dragon': 0.5,
    },
    'electric': {
      'water': 2.0,
      'electric': 0.5,
      'grass': 0.5,
      'ground': 0.0,
      'flying': 2.0,
      'dragon': 0.5,
    },
    'grass': {
      'fire': 0.5,
      'water': 2.0,
      'grass': 0.5,
      'poison': 0.5,
      'ground': 2.0,
      'flying': 0.5,
      'bug': 0.5,
      'rock': 2.0,
      'dragon': 0.5,
      'steel': 0.5,
    },
    'ice': {
      'fire': 0.5,
      'water': 0.5,
      'grass': 2.0,
      'ice': 0.5,
      'ground': 2.0,
      'flying': 2.0,
      'dragon': 2.0,
      'steel': 0.5,
    },
    'fighting': {
      'normal': 2.0,
      'ice': 2.0,
      'poison': 0.5,
      'flying': 0.5,
      'psychic': 0.5,
      'bug': 0.5,
      'rock': 2.0,
      'ghost': 0.0,
      'dark': 2.0,
      'steel': 2.0,
      'fairy': 0.5,
    },
    'poison': {
      'grass': 2.0,
      'poison': 0.5,
      'ground': 0.5,
      'rock': 0.5,
      'ghost': 0.5,
      'steel': 0.0,
      'fairy': 2.0,
    },
    'ground': {
      'fire': 2.0,
      'electric': 2.0,
      'grass': 0.5,
      'poison': 2.0,
      'flying': 0.0,
      'bug': 0.5,
      'rock': 2.0,
      'steel': 2.0,
    },
    'flying': {
      'electric': 0.5,
      'grass': 2.0,
      'fighting': 2.0,
      'bug': 2.0,
      'rock': 0.5,
      'steel': 0.5,
    },
    'psychic': {
      'fighting': 2.0,
      'poison': 2.0,
      'psychic': 0.5,
      'dark': 0.0,
      'steel': 0.5,
    },
    'bug': {
      'fire': 0.5,
      'grass': 2.0,
      'fighting': 0.5,
      'poison': 0.5,
      'flying': 0.5,
      'psychic': 2.0,
      'ghost': 0.5,
      'dark': 2.0,
      'steel': 0.5,
      'fairy': 0.5,
    },
    'rock': {
      'fire': 2.0,
      'ice': 2.0,
      'fighting': 0.5,
      'ground': 0.5,
      'flying': 2.0,
      'bug': 2.0,
      'steel': 0.5,
    },
    'ghost': {'normal': 0.0, 'psychic': 2.0, 'ghost': 2.0, 'dark': 0.5},
    'dragon': {'dragon': 2.0, 'steel': 0.5, 'fairy': 0.0},
    'dark': {
      'fighting': 0.5,
      'psychic': 2.0,
      'ghost': 2.0,
      'dark': 0.5,
      'fairy': 0.5,
    },
    'steel': {
      'fire': 0.5,
      'water': 0.5,
      'electric': 0.5,
      'ice': 2.0,
      'rock': 2.0,
      'steel': 0.5,
      'fairy': 2.0,
    },
    'fairy': {
      'fire': 0.5,
      'fighting': 2.0,
      'poison': 0.5,
      'dragon': 2.0,
      'dark': 2.0,
      'steel': 0.5,
    },
  };

  // Predefined status conditions
  final Map<String, StatusCondition> statusConditions = {
    'burn': StatusCondition(
      name: 'Burn',
      attackModifier: 0.5,
      damagePerTurn: 10,
      description:
          'Burns the target, causing damage each turn and reducing Attack.',
    ),
    'poison': StatusCondition(
      name: 'Poison',
      damagePerTurn: 8,
      description: 'Poisons the target, causing damage each turn.',
    ),
    'paralysis': StatusCondition(
      name: 'Paralysis',
      speedModifier: 0.5,
      description:
          'Paralyzes the target, reducing Speed and may cause immobility.',
    ),
    'sleep': StatusCondition(
      name: 'Sleep',
      durationTurns: 3,
      description: 'Target falls asleep and cannot move.',
    ),
    'freeze': StatusCondition(
      name: 'Freeze',
      durationTurns: 2,
      description: 'Target is frozen and cannot move.',
    ),
    'confusion': StatusCondition(
      name: 'Confusion',
      durationTurns: 4,
      description: 'Target is confused and may hurt itself.',
    ),
  };

  // Weather effects
  final Map<String, Map<String, dynamic>> weatherEffects = {
    'clear': {'description': 'The weather is clear.', 'modifiers': {}},
    'rain': {
      'description': 'It\'s raining!',
      'modifiers': {'water': 1.5, 'fire': 0.5},
    },
    'harsh_sunlight': {
      'description': 'The sunlight is harsh!',
      'modifiers': {'fire': 1.5, 'water': 0.5},
    },
    'sandstorm': {
      'description': 'A sandstorm is raging!',
      'modifiers': {'rock': 1.3},
      'damage': true,
      'immune_types': ['rock', 'ground', 'steel'],
    },
    'hail': {
      'description': 'It\'s hailing!',
      'modifiers': {'ice': 1.3},
      'damage': true,
      'immune_types': ['ice'],
    },
  };

  /// Calculates the damage from attacker to defender using a specific move
  int calculateDamage({
    required Pokemon attacker,
    required Pokemon defender,
    required Move move,
  }) {
    // Return 0 if it's a status move
    if (move.category == MoveCategory.status) return 0;

    // Check if move hits
    if (!checkAccuracy(attacker, defender, move)) {
      return -1; // Indicates a miss
    }

    // Check if move can affect the target
    double typeMultiplier = calculateTypeEffectiveness(
      move.type,
      defender.types,
    );
    if (typeMultiplier == 0) {
      return -2; // Indicates immunity
    }

    // Base damage calculation
    bool isPhysical = move.category == MoveCategory.physical;
    int attackStat =
        isPhysical
            ? attacker.getModifiedStat('attack')
            : attacker.getModifiedStat('specialAttack');
    int defenseStat =
        isPhysical
            ? defender.getModifiedStat('defense')
            : defender.getModifiedStat('specialDefense');

    // Same Type Attack Bonus (STAB)
    double stab = attacker.types.contains(move.type) ? 1.5 : 1.0;

    // Weather effect
    double weatherModifier = 1.0;
    if (currentWeather != 'clear') {
      var weather = weatherEffects[currentWeather]!;
      if (weather['modifiers']!.containsKey(move.type)) {
        weatherModifier = weather['modifiers']![move.type];
      }
    }

    // Random factor (85% to 100%)
    double randomFactor = _random.nextDouble() * 0.15 + 0.85;

    // Critical hit (6.25% chance)
    bool isCritical = _random.nextDouble() < 0.0625;
    double criticalMultiplier = isCritical ? 1.5 : 1.0;

    // Final damage calculation
    double damage =
        ((2 * attacker.baseHp / 5 + 2) *
            move.power *
            attackStat /
            (defenseStat * 50));
    damage =
        damage *
        stab *
        typeMultiplier *
        weatherModifier *
        criticalMultiplier *
        randomFactor;

    return max(1, damage.round());
  }

  bool checkAccuracy(Pokemon attacker, Pokemon defender, Move move) {
    if (move.accuracy == 100) return true;

    int accuracyMod = attacker.statModifiers['accuracy'] ?? 0;
    int evasionMod = defender.statModifiers['evasion'] ?? 0;

    double finalAccuracy =
        move.accuracy *
        getStatModifierMultiplier(accuracyMod) /
        getStatModifierMultiplier(evasionMod);
    return _random.nextDouble() * 100 < finalAccuracy;
  }

  double getStatModifierMultiplier(int modifier) {
    return (modifier >= 0) ? (3 + modifier) / 3 : 3 / (3 - modifier);
  }

  double calculateTypeEffectiveness(
    String moveType,
    List<String> defenderTypes,
  ) {
    double effectiveness = 1.0;

    for (String defenderType in defenderTypes) {
      double multiplier = _typeEffectiveness[moveType]?[defenderType] ?? 1.0;
      effectiveness *= multiplier;
    }

    return effectiveness;
  }

  bool canApplyStatusEffect(StatusCondition effect, Pokemon target) {
    if (target.status != null) return false;

    if (effect.name == 'Burn' && target.types.contains('fire')) return false;
    if (effect.name == 'Poison' &&
        (target.types.contains('poison') || target.types.contains('steel'))) {
      return false;
    }
    if (effect.name == 'Paralysis' && target.types.contains('ground')) {
      return false;
    }
    if (effect.name == 'Freeze' && target.types.contains('ice')) return false;

    return true;
  }

  String performTurn({
    required Pokemon attacker,
    required Pokemon defender,
    required int moveIndex,
  }) {
    turnCounter++;
    String result = "=== Turn $turnCounter ===\n";

    if (attacker.status?.name == 'Sleep' || attacker.status?.name == 'Freeze') {
      result +=
          "${attacker.name} is ${attacker.status!.name == 'Sleep' ? 'asleep' : 'frozen'} and can't move!\n";
      String statusResult = attacker.processStatusEffects();
      if (statusResult.isNotEmpty) result += "$statusResult\n";
      return result;
    }

    if (attacker.status?.name == 'Confusion') {
      if (_random.nextDouble() < 0.33) {
        int selfDamage = (attacker.baseHp * 0.1).round();
        attacker.currentHp -= selfDamage;
        result +=
            "${attacker.name} is confused and hurt itself! (-$selfDamage HP)\n";
        return result;
      }
    }

    if (attacker.status?.name == 'Paralysis') {
      if (_random.nextDouble() < 0.25) {
        result += "${attacker.name} is paralyzed and can't move!\n";
        return result;
      }
    }

    final move = attacker.moves[moveIndex];
    if (attacker.remainingPP < 5) {
      result +=
          "${attacker.name} doesn't have enough energy to use ${move.name}!\n";
      return result;
    }
    attacker.remainingPP -= 5;

    result += "${attacker.name} used ${move.name}!\n";

    if (move.category == MoveCategory.status) {
      if (move.effect != null && _random.nextDouble() < move.effectChance) {
        if (canApplyStatusEffect(move.effect!, defender)) {
          defender.applyStatus(move.effect!);
          result +=
              "${defender.name} was afflicted with ${move.effect!.name}!\n";
        } else {
          result += "But it failed!\n";
        }
      }

      if (move.name == "Growl") {
        defender.applyStatModifier('attack', -1);
        result += "${defender.name}'s Attack fell!\n";
      } else if (move.name == "Tail Whip") {
        defender.applyStatModifier('defense', -1);
        result += "${defender.name}'s Defense fell!\n";
      } else if (move.name == "Growth") {
        attacker.applyStatModifier('attack', 1);
        attacker.applyStatModifier('specialAttack', 1);
        result += "${attacker.name}'s Attack and Special Attack rose!\n";
      }

      return result;
    }

    final damage = calculateDamage(
      attacker: attacker,
      defender: defender,
      move: move,
    );

    if (damage == -1) {
      result += "${attacker.name}'s attack missed!\n";
      return result;
    }

    if (damage == -2) {
      result += "It doesn't affect ${defender.name}...\n";
      return result;
    }

    defender.currentHp = max(0, defender.currentHp - damage);

    double effectiveness = calculateTypeEffectiveness(
      move.type,
      defender.types,
    );
    if (effectiveness > 1.0) {
      result += "It's super effective!\n";
    } else if (effectiveness < 1.0 && effectiveness > 0.0) {
      result += "It's not very effective...\n";
    }

    if (_random.nextDouble() < 0.0625) {
      result += "A critical hit!\n";
    }

    result += "It dealt $damage damage!\n";
    result += "${defender.name} has ${defender.currentHp} HP left.\n";

    if (move.effect != null && _random.nextDouble() < move.effectChance) {
      if (canApplyStatusEffect(move.effect!, defender)) {
        defender.applyStatus(move.effect!);
        result += "${defender.name} was afflicted with ${move.effect!.name}!\n";
      }
    }

    if (defender.isFainted) {
      result += "${defender.name} fainted!\n";
      battleEnded = true;
    }

    String statusResult = attacker.processStatusEffects();
    if (statusResult.isNotEmpty) result += "$statusResult\n";

    if (weatherTurnsLeft > 0) {
      weatherTurnsLeft--;
      if (weatherTurnsLeft == 0) {
        result += "The weather returned to normal.\n";
        currentWeather = 'clear';
      } else {
        // Apply weather damage if applicable
        var weather = weatherEffects[currentWeather]!;
        if (weather['damage'] == true) {
          List<String> immuneTypes = weather['immune_types'] ?? [];
          bool isImmune = defender.types.any(
            (type) => immuneTypes.contains(type),
          );

          if (!isImmune) {
            int weatherDamage = (defender.baseHp * 0.0625).round();
            defender.currentHp = max(0, defender.currentHp - weatherDamage);
            result +=
                "${defender.name} is hurt by the $currentWeather! (-$weatherDamage HP)\n";

            if (defender.isFainted) {
              result += "${defender.name} fainted!\n";
              battleEnded = true;
            }
          }
        }
      }
    }

    return result;
  }

  /// Sets weather condition for the battlefield
  String setWeather(String weather, int duration) {
    if (!weatherEffects.containsKey(weather)) {
      return "Invalid weather condition!";
    }

    currentWeather = weather;
    weatherTurnsLeft = duration;
    return weatherEffects[weather]!['description'];
  }

  /// Determines the winner based on which Pokémon has HP left
  String checkWinner(Pokemon p1, Pokemon p2) {
    if (p1.isFainted && p2.isFainted) return "It's a draw!";
    if (p1.isFainted) return "${p2.name} wins!";
    if (p2.isFainted) return "${p1.name} wins!";
    return "Battle continues...";
  }

  /// Determines which Pokémon moves first based on speed and move priority
  int determineFirstMover(Pokemon p1, Pokemon p2, Move p1Move, Move p2Move) {
    // Check move priority first
    if (p1Move.priority.value > p2Move.priority.value) return 0;
    if (p2Move.priority.value > p1Move.priority.value) return 1;

    // If priority is the same, check speed
    int p1Speed = p1.getModifiedStat('speed');
    int p2Speed = p2.getModifiedStat('speed');

    if (p1Speed > p2Speed) return 0;
    if (p2Speed > p1Speed) return 1;

    // If speed is also tied, choose randomly
    return _random.nextBool() ? 0 : 1;
  }

  /// Handles a complete battle round where both Pokémon choose moves
  String executeBattleRound(
    Pokemon p1,
    Pokemon p2,
    int p1MoveIndex,
    int p2MoveIndex,
  ) {
    if (battleEnded) {
      return "The battle has already ended!";
    }

    Move p1Move = p1.moves[p1MoveIndex];
    Move p2Move = p2.moves[p2MoveIndex];

    int firstMover = determineFirstMover(p1, p2, p1Move, p2Move);
    String result = "";

    if (firstMover == 0) {
      // P1 goes first
      result += performTurn(attacker: p1, defender: p2, moveIndex: p1MoveIndex);
      if (!p2.isFainted) {
        result +=
            "\n${performTurn(attacker: p2, defender: p1, moveIndex: p2MoveIndex)}";
      }
    } else {
      // P2 goes first
      result += performTurn(attacker: p2, defender: p1, moveIndex: p2MoveIndex);
      if (!p1.isFainted) {
        result +=
            "\n${performTurn(attacker: p1, defender: p2, moveIndex: p1MoveIndex)}";
      }
    }

    // Check for battle end
    if (p1.isFainted || p2.isFainted) {
      result += "\n=== Battle Result ===\n";
      result += checkWinner(p1, p2);
      battleEnded = true;
    }

    battleLog.add(result);
    return result;
  }

  /// Simulates healing a Pokémon
  String healPokemon(Pokemon pokemon, int amount) {
    int oldHp = pokemon.currentHp;
    pokemon.currentHp = min(pokemon.baseHp, pokemon.currentHp + amount);
    int healed = pokemon.currentHp - oldHp;
    return "${pokemon.name} recovered $healed HP!";
  }

  /// Simulates using an item to restore PP
  String restorePP(Pokemon pokemon, int amount) {
    int oldPP = pokemon.remainingPP;
    pokemon.remainingPP = min(100, pokemon.remainingPP + amount);
    int restored = pokemon.remainingPP - oldPP;
    return "${pokemon.name} restored $restored PP!";
  }

  /// Creates sample moves for testing
  static List<Move> getSampleMoves(String type) {
    switch (type) {
      case 'fire':
        return [
          Move(
            name: "Ember",
            power: 40,
            type: "fire",
            effect: StatusCondition(
              name: "Burn",
              attackModifier: 0.5,
              damagePerTurn: 10,
              description:
                  "Burns the target, dealing damage each turn and reducing Attack.",
            ),
            effectChance: 0.1,
            description: "A weak fire attack that may burn the target.",
          ),
          Move(
            name: "Flamethrower",
            power: 90,
            type: "fire",
            category: MoveCategory.special,
            effect: StatusCondition(
              name: "Burn",
              attackModifier: 0.5,
              damagePerTurn: 10,
              description:
                  "Burns the target, dealing damage each turn and reducing Attack.",
            ),
            effectChance: 0.1,
            description: "A powerful fire attack that may burn the target.",
          ),
          Move(
            name: "Fire Spin",
            power: 35,
            type: "fire",
            category: MoveCategory.special,
            effect: StatusCondition(
              name: "Trap",
              damagePerTurn: 8,
              durationTurns: 4,
              description:
                  "Traps the target, preventing escape and dealing damage each turn.",
            ),
            effectChance: 1.0,
            description:
                "Traps the target in a vortex of flame for several turns.",
          ),
          Move(
            name: "Will-O-Wisp",
            power: 0,
            type: "fire",
            category: MoveCategory.status,
            effect: StatusCondition(
              name: "Burn",
              attackModifier: 0.5,
              damagePerTurn: 10,
              description:
                  "Burns the target, dealing damage each turn and reducing Attack.",
            ),
            effectChance: 1.0,
            accuracy: 85,
            description: "Inflicts a burn on the target.",
          ),
        ];
      case 'water':
        return [
          Move(
            name: "Water Gun",
            power: 40,
            type: "water",
            category: MoveCategory.special,
            description: "Shoots water at the target.",
          ),
          Move(
            name: "Hydro Pump",
            power: 110,
            type: "water",
            category: MoveCategory.special,
            accuracy: 80,
            description: "A powerful water attack with lower accuracy.",
          ),
          Move(
            name: "Bubble",
            power: 40,
            type: "water",
            category: MoveCategory.special,
            effect: StatusCondition(
              name: "Speed Down",
              speedModifier: 0.67,
              durationTurns: 3,
              description: "Lowers the target's Speed.",
            ),
            effectChance: 0.1,
            description: "Shoots bubbles that may lower the target's Speed.",
          ),
          Move(
            name: "Rain Dance",
            power: 0,
            type: "water",
            category: MoveCategory.status,
            description: "Changes the weather to rain for 5 turns.",
          ),
        ];
      case 'grass':
        return [
          Move(
            name: "Vine Whip",
            power: 45,
            type: "grass",
            description: "Strikes the target with slender vines.",
          ),
          Move(
            name: "Razor Leaf",
            power: 55,
            type: "grass",
            description: "Has a high critical hit ratio.",
          ),
          Move(
            name: "Sleep Powder",
            power: 0,
            type: "grass",
            category: MoveCategory.status,
            accuracy: 75,
            effect: StatusCondition(
              name: "Sleep",
              durationTurns: 3,
              description: "Puts the target to sleep.",
            ),
            effectChance: 1.0,
            description: "Puts the target to sleep if it hits.",
          ),
          Move(
            name: "Growth",
            power: 0,
            type: "grass",
            category: MoveCategory.status,
            description: "Raises the user's Attack and Special Attack.",
          ),
        ];
      case 'electric':
        return [
          Move(
            name: "Thunder Shock",
            power: 40,
            type: "electric",
            category: MoveCategory.special,
            effect: StatusCondition(
              name: "Paralysis",
              speedModifier: 0.5,
              description:
                  "Paralyzes the target, reducing Speed and may prevent movement.",
            ),
            effectChance: 0.1,
            description: "A weak electric attack that may paralyze the target.",
          ),
          Move(
            name: "Thunderbolt",
            power: 90,
            type: "electric",
            category: MoveCategory.special,
            effect: StatusCondition(
              name: "Paralysis",
              speedModifier: 0.5,
              description:
                  "Paralyzes the target, reducing Speed and may prevent movement.",
            ),
            effectChance: 0.1,
            description:
                "A strong electric attack that may paralyze the target.",
          ),
          Move(
            name: "Thunder Wave",
            power: 0,
            type: "electric",
            category: MoveCategory.status,
            effect: StatusCondition(
              name: "Paralysis",
              speedModifier: 0.5,
              description:
                  "Paralyzes the target, reducing Speed and may prevent movement.",
            ),
            effectChance: 1.0,
            description: "A weak electric charge that paralyzes the target.",
          ),
          Move(
            name: "Thunder",
            power: 110,
            type: "electric",
            category: MoveCategory.special,
            accuracy: 70,
            effect: StatusCondition(
              name: "Paralysis",
              speedModifier: 0.5,
              description:
                  "Paralyzes the target, reducing Speed and may prevent movement.",
            ),
            effectChance: 0.3,
            description:
                "A powerful electric attack with lower accuracy. May paralyze.",
          ),
        ];
      default:
        return [
          Move(
            name: "Tackle",
            power: 40,
            type: "normal",
            description: "A basic physical attack.",
          ),
          Move(
            name: "Quick Attack",
            power: 40,
            type: "normal",
            priority: MovePriority.high,
            description: "Always goes first.",
          ),
          Move(
            name: "Scratch",
            power: 40,
            type: "normal",
            description: "A basic physical attack.",
          ),
          Move(
            name: "Growl",
            power: 0,
            type: "normal",
            category: MoveCategory.status,
            description: "Lowers the target's Attack.",
          ),
        ];
    }
  }

  /// Creates a sample Pokémon for testing
  static Pokemon createSamplePokemon(
    String name,
    String primaryType, {
    String? secondaryType,
  }) {
    List<String> types = [primaryType];
    if (secondaryType != null) {
      types.add(secondaryType);
    }

    Map<String, int> baseStats;
    switch (primaryType) {
      case 'fire':
        baseStats = {
          'hp': 78,
          'attack': 84,
          'defense': 78,
          'specialAttack': 109,
          'specialDefense': 85,
          'speed': 100,
        };
        break;
      case 'water':
        baseStats = {
          'hp': 79,
          'attack': 83,
          'defense': 100,
          'specialAttack': 85,
          'specialDefense': 105,
          'speed': 78,
        };
        break;
      case 'grass':
        baseStats = {
          'hp': 80,
          'attack': 82,
          'defense': 83,
          'specialAttack': 100,
          'specialDefense': 100,
          'speed': 80,
        };
        break;
      case 'electric':
        baseStats = {
          'hp': 60,
          'attack': 65,
          'defense': 60,
          'specialAttack': 110,
          'specialDefense': 95,
          'speed': 130,
        };
        break;
      default:
        baseStats = {
          'hp': 70,
          'attack': 80,
          'defense': 70,
          'specialAttack': 70,
          'specialDefense': 70,
          'speed': 70,
        };
    }

    return Pokemon(
      name: name,
      baseHp: baseStats['hp']!,
      attack: baseStats['attack']!,
      defense: baseStats['defense']!,
      specialAttack: baseStats['specialAttack']!,
      specialDefense: baseStats['specialDefense']!,
      speed: baseStats['speed']!,
      types: types,
      moves: getSampleMoves(primaryType),
      ability: getPokemonAbility(primaryType),
    );
  }

  /// Returns a sample ability based on type
  static String getPokemonAbility(String type) {
    switch (type) {
      case 'fire':
        return 'Blaze';
      case 'water':
        return 'Torrent';
      case 'grass':
        return 'Overgrow';
      case 'electric':
        return 'Static';
      default:
        return 'Adaptability';
    }
  }
}
