use std::fs::File;
use std::io::prelude::*;
use std::cell::Cell;
use std::collections::HashMap;

struct Node {
    weight: u32,
    children: Vec<String>,
    parent: Cell<String>,
}

fn get_name(name_and_rest: String) -> (String, String) {
    let splitted: Vec<String> = name_and_rest.split('(')
        .map(|s| s.to_string())
        .collect();
    (splitted[0].clone(), splitted[1].clone())
}

fn get_weight(weight_and_rest: String) -> (u32, String) {
    let splitted: Vec<String> = weight_and_rest.split(')')
        .map(|s| s.to_string())
        .collect();
    (splitted[0].parse().expect("Weight is not a number!"), splitted[1].clone())
}

fn get_children(children_string: String) -> Vec<String> {
    children_string.replace("->", "")
        .split(',')
        .map(|s| s.to_string())
        .collect()
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
        let (name, rest) = get_name(l);
        let (node_weight, rest) = get_weight(rest);

        let mut children = Vec::new();
        if rest.starts_with("->") {
            children = get_children(rest);
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
    println!("root node: {}", current_node)
}