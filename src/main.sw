// SPDX-License-Identifier: GPL-3.0
/*
Copyright 2021 0KIMS association.

This file is generated with [snarkJS](https://github.com/iden3/snarkjs).

snarkJS is a free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

snarkJS is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
License for more details.

You should have received a copy of the GNU General Public License
along with snarkJS. If not, see
<https: //www.gnu.org/licenses />.
*/

contract;

// Scalar field size
const R: u256 = 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001u256;
// Base field size
const Q: u256 = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47u256;

// Verification Key data
const ALPHA_X: u256 = 0x7e21520a53db15dab72fc76f2674e3b45785fcfbc2e88a192a25642bdd1790bu256;
const ALPHA_Y: u256 = 0x20c6790259446bc952078671a96a0bcc554cd14949f51cb00fd06d211d18fe39u256;
const BETA_X1: u256 = 0x8da61abd3e02f58ade771514cb83cf2b10a4b55b22c7700a7a9d20c2aee344fu256;
const BETA_X2: u256 = 0x206361d98b50c31a80e6ad05f98a5dc8aad13a19cc7f7f1d47eb5c8c9ce2fa8eu256;
const BETA_Y1: u256 = 0x1b0918d6c86002e91be8459fca6d4526ef2446af57ef9fcbe2a3c04a806aefb7u256;
const BETA_Y2: u256 = 0xf5c86769b9231b9cc0ef1d2da8a32d9e20aa6a432b8919c4cf308ddbba559c5u256;
const GAMMA_X1: u256 = 0x198e9393920d483a7260bfb731fb5d25f1aa493335a9e71297e485b7aef312c2u256;
const GAMMA_X2: u256 = 0x1800deef121f1e76426a00665e5c4479674322d4f75edadd46debd5cd992f6edu256;
const GAMMA_Y1: u256 = 0x90689d0585ff075ec9e99ad690c3395bc4b313370b38ef355acdadcd122975bu256;
const GAMMA_Y2: u256 = 0x12c85ea5db8c6deb4aab71808dcb408fe3d1e7690c43d37b4ce6cc0166fa7daau256;
const DELTA_X1: u256 = 0x161301133ad1d73e5da3b33f6e2247ea8da9c8cadb2da3fb3071315e1b8b1f3u256;
const DELTA_X2: u256 = 0x6b20c3b2d89fc155aec39d0402d2ec855a1578dbc4fa032dd11f8069ef43008u256;
const DELTA_Y1: u256 = 0x3ccd4ce282c2edd9c0219657124ee9b5bc316ad8a1b0f6d0f36d49fdc17f774u256;
const DELTA_Y2: u256 = 0x1f3b994a92cf6d0f31ad189be8334e802503ef051c6f0264d9a08833fcb3fa43u256;


const IC0_X: u256 = 0x1cbf3146a1b003117604929124849150e4447122c9c47651b3a65e474ccadca6u256;
const IC0_Y: u256 = 0xccb73c0c26ca038341db07f7cd16e11ba6aab0bf5ad0998ac298f75dd02d2e1u256;

const IC1_X: u256 = 0xa066355b142e14aefeb59d5efcc351c0a67a7c474f1d7c8d30fa5ea3ac77fcdu256;
const IC1_Y: u256 = 0x1953dad9946bcb09703df024d1d48b976f9578a1ac84f1bb621ab660fcd34c3eu256;


abi Groth16Verifier {
    fn verify_proof(
        p_a: [u256; 2],
        p_b: [[u256; 2]; 2],
        p_c: [u256; 2],
        pub_signals: [u256; 1],
    ) -> bool;
}

impl Groth16Verifier for Contract {
    fn verify_proof(
        p_a: [u256; 2],
        p_b: [[u256; 2]; 2],
        p_c: [u256; 2],
        pub_signals: [u256; 1],
    ) -> bool {
        // check inputs < R
        let mut i = 0;
        while i < 1 {
            if pub_signals[i] >= R {
                return false;
            }
            i += 1;
        }
        // check element in proof < Q
        if p_a[0] >= Q || p_a[1] >= Q || p_b[0][0] >= Q || p_b[0][1] >= Q || p_b[1][0] >= Q || p_b[1][1] >= Q || p_c[0] >= Q || p_c[1] >= Q {
            return false;
        };

        // compute the linear combination of X
        let mut x: [u256; 2] = [IC0_X, IC0_Y];
        let mut scalar_mul_input: [u256; 3] = [0; 3];
        let mut scalar_mul_output: [u256; 2] = [0; 2];
        let mut point_add_input: [u256; 4] = [0; 4];

            
        scalar_mul_input[0] = IC1_X;
        scalar_mul_input[1] = IC1_Y;
        scalar_mul_input[2] = pub_signals[0];
        // input_0 * ic_1
        asm(rA: scalar_mul_output, rB: 0, rC: 1, rD: scalar_mul_input) {
            ecop rA rB rC rD;
        }
        // x + input_0 * ic_1
        point_add_input[0] = x[0];
        point_add_input[1] = x[1];
        point_add_input[2] = scalar_mul_output[0];
        point_add_input[3] = scalar_mul_output[1];
        asm(rA: x, rB: 0, rC: 0, rD: point_add_input) {
            ecop rA rB rC rD;
        }
        

        // check the pairing equation
        let mut pairing_input: [u256; 24] = [0; 24];

        // -A
        pairing_input[0] = p_a[0];
        pairing_input[1] = (Q - p_a[1]) % Q;
        // B
        pairing_input[2] = p_b[0][0];
        pairing_input[3] = p_b[0][1];
        pairing_input[4] = p_b[1][0];
        pairing_input[5] = p_b[1][1];
        // alpha
        pairing_input[6] = ALPHA_X;
        pairing_input[7] = ALPHA_Y;
        // beta
        pairing_input[8] = BETA_X1;
        pairing_input[9] = BETA_X2;
        pairing_input[10] = BETA_Y1;
        pairing_input[11] = BETA_Y2;
        // x
        pairing_input[12] = x[0];
        pairing_input[13] = x[1];
        // gamma
        pairing_input[14] = GAMMA_X1;
        pairing_input[15] = GAMMA_X2;
        pairing_input[16] = GAMMA_Y1;
        pairing_input[17] = GAMMA_Y2;
        // c
        pairing_input[18] = p_c[0];
        pairing_input[19] = p_c[1];
        // delta
        pairing_input[20] = DELTA_X1;
        pairing_input[21] = DELTA_X2;
        pairing_input[22] = DELTA_Y1;
        pairing_input[23] = DELTA_Y2;

        let curve_id: u32 = 0;
        let groups_of_points: u32 = 4;

        let result = asm(rA, rB: curve_id, rC: groups_of_points, rD: pairing_input) {
            epar rA rB rC rD;
            rA: u32
        };

        result != 0

    }
}