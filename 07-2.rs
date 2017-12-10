use std::fs::File;
use std::io::prelude::*;
use std::cell::Cell;
use std::collections::HashMap;

struct Node {
    weight: i32,
    children: Vec<String>,
    parent: Cell<String>,
}

fn get_name_from_string(name_and_rest: String) -> (String, String) {
    let splitted: Vec<String> = name_and_rest.split('(')
        .map(|s| s.to_string())
        .collect();
    (splitted[0].clone(), splitted[1].clone())
}

fn get_weight_from_string(weight_and_rest: String) -> (i32, String) {
    let splitted: Vec<String> = weight_and_rest.split(')')
        .map(|s| s.to_string())
        .collect();
    (splitted[0].parse().expect("Weight is not a number!"), splitted[1].clone())
}

fn get_children_from_string(children_string: String) -> Vec<String> {
    children_string.replace("->", "")
        .split(',')
        .map(|s| s.to_string())
        .collect()
}

fn find_root_node(nodes: &HashMap<String, Node>) -> String {
    // pick arbitrary node to start from
    let mut current_node: String = "".to_string();
    for n in nodes.keys().take(1) {
        current_node = n.to_string();
    }
    // traverse tree to find the root node
    loop {
        let parent = nodes.get(&current_node)
            .expect("Node not found")
            .parent.take();
        if parent == "" {
            break;
        }
        current_node = parent;
    }
    current_node
}

fn get_weight_of(node: &String, nodes: &HashMap<String, Node>) -> i32 {
    let mut sum: i32 = nodes.get(node).expect("Node not found").weight;
    for c in &nodes.get(node).expect("Node not found").children {
        sum += get_weight_of(&c, nodes);
    }
    sum
}

fn main() {
    let mut file = File::open("07-input.txt")
        .expect("Unable to open the file");
    
    let mut contents = String::new();
    
    file.read_to_string(&mut contents)
        .expect("Unable to read the file");

    let mut nodes: HashMap<String, Node> = HashMap::new();

    let lines: Vec<&str> = contents.split('\n').collect();
    for l in lines {
        let l = l.replace(" ","").trim().to_string();
        let (name, rest) = get_name_from_string(l);
        let (node_weight, rest) = get_weight_from_string(rest);

        let mut children = Vec::new();
        if rest.starts_with("->") {
            children = get_children_from_string(rest);
        }
        
        nodes.insert(
            name,
            Node {
                weight: node_weight,
                children: children,
                parent: Cell::new("".to_string())
            }
        );
    }
    // add parents based on each node's children
    for (k, v) in &nodes {
        for c in &v.children {
            if let Some(x) = nodes.get(c) {
                x.parent.set(k.clone());
            }
        }
    }


    let mut root_node_name = find_root_node(&nodes);
    let mut imbalance: i32 = 0;
    loop {
        let root_node = nodes.get(&root_node_name).expect("Node not found");

        // traverse tree and count weights of sub-towers
        let mut subtower_list = Vec::new();
        println!("Current root: {}: {}",
            root_node_name, nodes.get(&root_node_name).expect("Node not found").weight);
        for subtower in &root_node.children {
            subtower_list.push((subtower.clone(), get_weight_of(&subtower, &nodes)));
            println!("-subtower {}: {}", subtower, get_weight_of(&subtower, &nodes));
        }

        subtower_list.sort_by_key(|k| k.1);
        let min_tower = subtower_list.first().expect("Subtower list is empty");
        let max_tower = subtower_list.last().expect("Subtower list is empty");
        if min_tower.1 != max_tower.1 {
            if subtower_list.len() > 2 {
                if subtower_list[1].1 == min_tower.1 {
                    println!("Imbalanced: {}: {}, others are {}", max_tower.0, max_tower.1, min_tower.1);
                    root_node_name = max_tower.0.clone();
                    imbalance = max_tower.1-min_tower.1;
                }
                else {
                    println!("Imbalanced: {}: {}, others are {}", min_tower.0, min_tower.1, max_tower.1);
                    root_node_name = min_tower.0.clone();
                    imbalance = min_tower.1-max_tower.1;
                }
            }
            println!();
        }
        else {
            let imba_weight = nodes.get(&root_node_name).expect("Node not found").weight;
            println!("Children are balanced, imbalanced node must be {}: {}", 
                root_node_name, imba_weight);
            println!("Its weight should be {}", imba_weight-imbalance);
            break;
        }
    }
}