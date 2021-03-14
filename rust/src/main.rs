/* Markov model program in Rust, based on Pike & Kerningham's C example from 'The Practice of
 * Programming'.
 */
use std::collections::HashMap;
use std::convert::TryInto;
use std::env;
use std::error::Error;
use std::fs;
use std::io::{self, BufReader, BufRead};

use rand::Rng;

const NPREF: u32  = 2;       // number of prefix words
const MAXGEN: u32 = 10000;   // maximum words generated

const NONWORD: &str = "\n";   // cannot appear as a real word

type Prefixes = Vec<String>;
type StateNode = Option<Box<State>>;

//#[derive(Hash, Eq, PartialEq, Debug)]
struct State {
    pref: Prefixes,
    suf: Option<String>,
    next: StateNode,
}

impl State {
    fn new(pref: &[String], suf: Option<String>, next: Option<Box<State>>) -> State {
        State {pref: pref.to_vec(), suf, next}
    }
}

struct StateList {
    head: StateNode,
}

impl StateList {
    fn new() -> Self {
        StateList { head: None }
    }

    fn push(&mut self, state: State) {
        let new_state = Box::new(State {
            pref: state.pref,
            suf:  state.suf,
            next: self.head.take(),
        });

        self.head = Some(new_state);
    }

    fn random(&self) -> Option<&State> {
        let mut rng = rand::thread_rng();
        let mut nmatch: u16 = 1;
        let mut state = self.head.as_ref();
        let mut ret_state = state;
        
        while state.is_some() {
            let rand: u16 = rng.gen::<u16>();
            if (rand % nmatch) == 0 { ret_state = state; }
            if state.as_ref().unwrap().next.is_none() { break; }
            state = (state.as_ref().unwrap().next).as_ref();

            nmatch += 1;
        }
        ret_state.map(|x| x.as_ref())
    }
}

// add: add word to suffix list, update prefix
fn add(states: &mut HashMap<Prefixes, StateList>, prefix: &mut Prefixes, suffix: String) {
    // create if not found
    let s = State::new(prefix, Some(suffix.clone()), None);
    let sl = StateList::new();

    if !states.contains_key(prefix) {
        states.insert(prefix.to_vec(), sl);
    };

    let state_list = match states.get_mut(prefix) {
        Some(v) => v,
        None    => unreachable!(),
    };

    state_list.push(s);

    // move the words down the prefix
    prefix.drain(0..1);
    prefix.push(suffix);
}

// build: read input, build prefix table
fn build(states: &mut HashMap<Prefixes, StateList>, prefix: &mut Prefixes,
         reader: Box<dyn BufRead>) -> Result<(), Box<dyn Error>> {
    for line in reader.lines() {
        for word in line?.split_whitespace() {
            add(states, prefix, word.to_string())
        }
    }
    Ok(())
}

fn generate(states: &HashMap<Prefixes, StateList>, nwords: u32) {
    let mut prefix: Prefixes = vec![String::from(NONWORD); NPREF.try_into().unwrap()];
    
    for _i in 0..nwords {
        let state = match states.get(&prefix.to_vec()) {
            Some(s) => s.random().unwrap(),
            None   => break, 
        };
        let suffix = state.suf.as_ref().unwrap();

        println!("{}", suffix);

        prefix.drain(0..1);
        prefix.push(suffix.to_string());
    };
}

fn main() {
    let input = env::args().nth(1);
    // Read from stdin or file (1st argument)
    let reader: Box<dyn BufRead> = match input {
        None => Box::new(BufReader::new(io::stdin())),
        Some(filename) => Box::new(BufReader::new(fs::File::open(filename).unwrap()))
    };

    let mut states: HashMap<Prefixes, StateList> = HashMap::new();

    let mut prefix: Prefixes = vec![String::from(NONWORD); NPREF.try_into().unwrap()];

    match build(&mut states, &mut prefix, reader) {
        Ok(f) => f,
        Err(e) => println!("Error: {}", e.to_string()),  
    }
    generate(&states, MAXGEN);
}
