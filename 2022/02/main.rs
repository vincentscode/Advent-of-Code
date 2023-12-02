use std::fs;
use std::collections::HashMap;

fn get_move<'a>(my_move: &'a str, enemy_move: &'a str) -> &'a str {
    // A: Rock       (1 Point)
    // B: Paper      (2 Points)
    // C: Scissors   (3 Points)

    // X: Lose
    // Y: Draw
    // Z: Win

    let lose_table = HashMap::from([
        ("A", "C"),
        ("B", "A"),
        ("C", "B"),
    ]);
    
    let draw_table = HashMap::from([
        ("A", "A"),
        ("B", "B"),
        ("C", "C"),
    ]);

    let win_table = HashMap::from([
        ("A", "B"),
        ("B", "C"),
        ("C", "A"),
    ]);

    if my_move == "X" {
        return lose_table[enemy_move];
    }

    if my_move == "Y" {
        return draw_table[enemy_move];
    }

    if my_move == "Z" {
        return win_table[enemy_move];
    }
    
    return "";
}

fn get_score(my_move: &str, enemy_move: &str) -> i32 {
    // X/A: Rock       (1 Point)
    // Y/B: Paper      (2 Points)
    // Z/C: Scissors   (3 Points)

    // Losing 0 Points
    // Draw 3 Points
    // Winning 6 Points

    let mut score;
    if my_move == "X" || my_move == "A" {
        score = 1;
        if enemy_move == "A" {
            score += 3;
        } else if enemy_move == "C" {
            score += 6;
        }
    } else if my_move == "Y" || my_move == "B" {
        score = 2;
        if enemy_move == "B" {
            score += 3;
        } else if enemy_move == "A" {
            score += 6;
        }
    } else if my_move == "Z" || my_move == "C" {
        score = 3;
        if enemy_move == "C" {
            score += 3;
        } else if enemy_move == "B" {
            score += 6;
        }
    } else {
        panic!("Invalid Move {:?}", my_move);
    }

    return score;
}

fn main() {
    let file_path = "input.txt";
    let contents = fs::read_to_string(file_path)
        .expect("Should have been able to read the file");
    let lines = contents.split("\n");

    let mut scores: Vec<i32> = vec![];
    let mut scores2: Vec<i32> = vec![];

    for line in lines {
        let parts = line.split(" ").take(2).collect::<Vec<&str>>();
        if let [enemy_move, my_move] = &parts[..] {
            scores.push(get_score(my_move, enemy_move));
            scores2.push(get_score(get_move(my_move, enemy_move), enemy_move));
        }
    }

    let total_score = scores.iter().sum::<i32>();
    println!("1 - Total Score: {}", total_score);
    let total_score2 = scores2.iter().sum::<i32>();
    println!("2 - Total Score: {}", total_score2);
}
