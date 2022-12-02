use std::fs;
use std::cmp::Ordering;

fn main() {
    let file_path = "input.txt";
    let contents = fs::read_to_string(file_path)
        .expect("Should have been able to read the file");
    let lines = contents.split("\n");

    let mut batches = vec![vec![]];
    let mut batch_count = 1;

    for line in lines {
        if line.len() == 0 {
            let last_batch = &batches[batch_count-1];
            println!("{last_batch:?}");

            batches.push(vec![]);
            batch_count += 1;
        } else {
            batches[batch_count-1].push(line);
        }
    }
    
    let batch_sums: Vec<_> = batches.iter().map(
        |x| x.iter().map(
            |x| x.parse::<i32>().unwrap()
        ).sum::<i32>()
    ).collect();
    println!("Sums: {batch_sums:?}");

    let max = batch_sums.iter().max().unwrap();
    let max_idx = batch_sums.iter().position(|e| e == max).unwrap();

    println!("Max: {max}");
    println!("Max Index: {max_idx}");

    let mut sorted: Vec<i32> = batch_sums.to_vec();
    sorted.sort();
    let top_three: Vec<_> = sorted.iter().rev().take(3).collect();
    let top_three_sum: i32 = sorted.iter().rev().take(3).sum();
    println!("Sorted Sums: {sorted:?}");
    println!("Top 3: {top_three:?}");
    println!("Top 3 Sum: {top_three_sum}");
}
