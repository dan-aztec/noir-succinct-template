use dep::std::hash::sha256;
use dep::std::println;

fn main(input_bytes: [u8; 8])-> pub (Field, Field) {
    let input_hash = sha256(input_bytes);

    let mut power: u32 = 1;
    let mut a: u32 = 0;
    let mut b: u32 = 0;
    for i in 0..4 {
        a += (input_bytes[i] as u32) * power;
        b += (input_bytes[i+4] as u32) * power;
        power *= 2;
    } 
    let c: u32 = a + b;
    let output_bytes = (c as Field).to_le_bytes(32);
    println(c);
    let output_hash = sha256(output_bytes);

    let mut input_hash_el: Field = 0;
    let mut output_hash_el: Field = 0;

    let mut power: Field = 1;
    for i in (0 as u32)..(32 as u32) {
        let input_hash_bits = (input_hash[i] as Field).to_le_bits(8);
        let output_hash_bits = (output_hash[i] as Field).to_le_bits(8);
        for j in (0 as u32)..(8 as u32) {
            if i*8 + j < 253 {
                input_hash_el += (input_hash_bits[j] as Field) * power;
                output_hash_el += (output_hash_bits[j] as Field) * power;
            }
            power *= 2;
        }
    }

    (input_hash_el, output_hash_el)
}

#[test]
fn test_main() {
    // main(1, 2);

    // Uncomment to make test fail
    // main(1, 1);
}
