// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "../../../TaikoTest.sol";

/// @author Kirk Baird <kirk@sigmaprime.io>
contract TestSecureMerkleTrie is TaikoTest {
    function test_verifyInclusionProof_simple() external {
        bytes memory slot = hex"0000000000000000000000000000000000000000000000000000000000000006"; // hash
            // = 0xf652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d3f
        bytes memory value = hex"01";
        // Leaf node (target):
        // ["0x3652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d3f","0x01"] // hash =
        // 4c020f5af4649ee703bbfa974846790d332abacef03c89036babb2238c01c337
        // Branch node (root):
        // ["0x","0x","0x","0x","0x","0x","0x","0x","0x","0x","0x","0x","0x","0x","0x","0x4c020f5af4649ee703bbfa974846790d332abacef03c89036babb2238c01c337",
        // "0x"] // hash = b21a635028fc2f2a4ba5b688497165f7096500771fd493e0695ef750c6c1845c

        bytes32 rootHash = hex"b21a635028fc2f2a4ba5b688497165f7096500771fd493e0695ef750c6c1845c";

        bytes[] memory proof = new bytes[](2);
        proof[0] =
            hex"f1808080808080808080808080808080a04c020f5af4649ee703bbfa974846790d332abacef03c89036babb2238c01c33780";
        proof[1] = hex"e2a03652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d3f01";

        assertTrue(SecureMerkleTrie.verifyInclusionProof(slot, value, proof, rootHash));
    }

    // based on deployed contract 0xcD5e2bebd3DfE46e4BF96aE2ac7B89B22cc6a982 (SignalService Proxy)
    // on Sepolia
    function test_verifyInclusionProof_realProof() external {
        bytes memory slot = hex"0000000000000000000000000000000000000000000000000000000000000000";
        bytes memory value = hex"01";
        bytes32 rootHash = hex"45e9f670f31850ee0771a6ce85f36721526bc413bd91d58b8b9002adacb418ca";

        bytes[] memory proof = new bytes[](6);
        proof[0] =
            hex"f90211a01bf8dc9db1d06b09a1593db05232aa42c2b417e20251d71e8f32086b57573e06a0f541e279cb44d7e034fd4a8fda716291d8bb5cc2fb67249197c373e4405333d9a09ac7f4d030a807bf868f0e9122a537e6ea6f029a3bbae5477f5bec9367477538a012795298d14f24c7876a15303f38c794fe4d22c385d6b15adf136a65287d64aca0db8ff50aeed396a753e2b582a2101807146b9abad224956c8c0b2914e8bc6308a050e2462dd19498a35aabf6a701e90756cd519129c04095fde7b35ced53548967a01d4d98eae2c34085bef8029256fbc79dfd08ce2413742e006c16057ee23d8415a05ee9d91e8763e4ab8bfddb682f1579d91189d77435e69e186788b1236c07b400a06e867457693097e1ac54bca407a9b7241740e64d110e661b71b708776bf951cea038440f0f7488fc76ba3f7a35b1789dd4658b9b206441ef824acb7fe2a3a76a20a0285e98d81740593ef5a9a529c4d733ebe64f15f40732b3a0d0623c1cb71f8ed0a0a80dd18c30ffd2792e4856b13097aad1e5afe7439b7f343cf9ae856d68af2ba7a0c2d74f432cab091d90bae5ec862089ae1272f39108f1cba4f57c7b5671e5c816a0aceebc0b41cf40fe8313c2b524f03e732b8385727de1abae876d9057b2d85e1fa00ee8b4f21e2f328d027884d9ffbac6fac35539a7d74b11d9f17e5a3a185b8386a0e52242d3cc5dd7773ec21fbfae2141144d02ce74ff601c375bda5fff96aef12b80";
        proof[1] =
            hex"f90211a09c081fac815d03d3ef97f0f6ec100c24a7057fff79a870a22756b374a67a67eaa008586c30da747166360003b1eed874a0b915ca98cbfa84964f7d88ab8da1989aa0449474ec27502c1a3a5d21050bbfd57cc514adae298412e23f132534ff932dfca08434310370976516d70c7b3b6b33a383e46a94563ec48da41ce3074141c29d37a0912079ec50d4499209c32b2f7dd8d12cb9c152136812df496876fae92d485335a0505627a88c1028e9ce54238f9f5d79e196b9fee338aa642afe511886ed53f04aa0e411917634b30a3767de43f4208ee6a7bef92e63e4afd83b9318da18b5664a6ea03f5bbccdf60e44fa45761b107f34166d4b511d0343af2464afed818dfdc57963a002920171377ba261586e2733d3d0f19696b44848abb95ad91b08484f7cbe74bea0815f25e6680089a62b7219ee2957b19e773d41545fe2140a4dbcd7e8cd3dffd7a0204c53730d2e8b4840012807a3ccfb3dab97a9abcbddea7b470e72c31ed47e64a0e37b499b1b6139944109adfffe5a303f26efc14627a85bdd06f5f67fa18d1f27a070660c887064df8b7d89a942b0553427dd18f06b8bbb39db5365786e780fc749a07b51a6dbe67bad62c92538c859a66937162cb61a000d7e5f21695e490199b18ba0b80c116ca1493c4a017f3189e519614295c4ec23edcaa199f16f64ad9b9527c7a09cea6ec2caee96a5cacbae86e88c15e0f2a5d26d4b75137179fd5666fbb5aa7480";
        proof[2] =
            hex"f90211a0edff33fe5c95b4fa868d66431769e22577932ee13b18b1da8ee5419aec59c5e7a09320d0ae25a44b54b44f69b435a3edb6503d0aab80052a4ba2d0069e840ffcf3a084d002a67ee8281c3681b11d948ab4d2a6440a2803f6025b54dcaa4a2bb86047a00104b82f9c6c5a0d3bc9f1af1ccde26293e680e26d525f9d542a9ebb5d623eada02b2522787d006e41d10c12bff567be8eb13ca23784a926eddeda28550bc50843a03d02c42758d7f7107850431572c6275b64a9da09107d588c732a45804ec8b650a0be4b44daa2d677c7163e0b6b8334c39ddb92ae0701b573196ed2e422d08d7f79a0c4c06e7eded093383c6c3e2460462a49d356a4fc3165ec0207490cf62b382653a0d54b62359a6a9c0541e660b151009cc42a48e3ba12b7059e7aa40ea55f7d627fa08ee6a1a4cc20035c4ac7aea9d80dfc1dd13d83b9c9941c180caf0496a261a525a02885741fff2f4e61c3cd76ea387978030d9d0a79d2accdaaa535e9fd69be9dc0a013f67d5965341a354b659eddf810ad1801ed6cdbc85922fbf4f1d5690d4dec5ea0014ce0d9af419fb75af5ebf396786cd3f415429d30e174c864c6f355e46e9e9fa04ad594c616d61e8b911359309131516d9e29d9a435cec91520d0831bcee6752fa06aeb091d8001bf97c0861ea1900e85edad54c00e7d368fae73a5d980a4479a2da07e2aa9f31c59e36b69154fbd34de81c6b1feed1a6ed868813e923d2f98d8c31480";
        proof[3] =
            hex"f90211a0d2c363378ebc8717d552d4137cba842e6d00f045121f885d88f1146121c299e5a09f6f5a03356b3033f75fba1956afe0242be8dc508ce83e356ea5f48b3c17b571a0ba32e8ef62fdfc524822241c471024cba2b1d4a6a9d049424e2ac3868435f2eaa0284ecc45af9d2cc173636750eef4fc9c3e8828a5469732571950259cd25b2ae5a0a4a384dba0939acbcc8b14ce2411df265cc91162debb84ffd94f9a5f185e6c04a02542ba4e13a2571665afb8a8d6b5e972e018d1d6f3ae57707d725254530f27aaa05b1f61c8dea59ac83181d4faa4d3c322970f5ecacd0bd07028bc87b6e3174baba02fa86ead02062c2671a3de5460efe03e179184e3602320ab8478aa51239ca5f1a0b0a1ed80fa8eef67af1193c2080d04976d2b28ed3a70ad64afc9d31864ddf0d3a0afd61230c619715051e37d73754063a58da86e17fa9f1f702038b88b762fda4ea0cdb772381aec1978ad17c8c0e13298b1f9ce4b937f45a7b5ade7bce5ec374665a0db07f3614888c57b8ccbddca9e1575e63b663acada279262261b43e8d328ba88a00de0759c749651d9b8960feed63fbeecaaa145f47927e7f2d2d3f56bb802d676a01c3384e31a91e9d39ee8c728c24cf49a2d1c27ed4d96075c760d470e0812731da07e7fc146b9cc0be8af894c7a6cd93b4857011483f299c5b68737de3f0eb53304a0466878f42b7f4b98bdf104bede4313aade1c2cf0186db3e5806b74935129d00e80";
        proof[4] =
            hex"f90171a031dde6777fd092b1b9769b2402355e81e3e03e5d5c336f5edc583836ed15cfa580a0bb779ade81cb7fa701d963b9c1ae32d7cf58d926d14217bf96e3b44cdc93426da08cfeef6342385fbb0b452adca5c2ae1c5c651839137c15ce646d2a2011358e0ba0354480a6556b60a6af02f5f138eac24b268af77d85b3a7e241b1c6ec30125e17a08b6d79c69add140fd1bdd694ded36b248961ce0a6c905aac15ae928b925d730f80a0665dd3eb57bd0fd5bf2476a2c7ce190bbe4cfe92862d2ca644ec2f24a5e1545980a0321c382b719c93b3d816c3876a5f36b265186988c4a7994bc5927357f64d82bfa0adbd467e4d446b07a0f755954da22d7480373fdb139e93ec52799aa4239571a980a0a3eed0a41205afb11767756e464a4b99b0cbec8ac9f0919f46b831118a6847f880a0954e8545cb42ac37f2ef0f79f745a03c660dd143a7b621132385060a8345e821a00fe18033d0e53a5d97855111b656f4aefc4b32538df7aba9a01592bb1337d15380";
        proof[5] = hex"e09e3cd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e56301";

        assertTrue(SecureMerkleTrie.verifyInclusionProof(slot, value, proof, rootHash));
    }

    function test_verifyInclusionProof_fakeValue() external {
        bytes memory slot = hex"0000000000000000000000000000000000000000000000000000000000000006";
        bytes memory value = hex"ff";
        bytes32 rootHash = hex"b21a635028fc2f2a4ba5b688497165f7096500771fd493e0695ef750c6c1845c";

        bytes[] memory proof = new bytes[](2);
        proof[0] =
            hex"f1808080808080808080808080808080a04c020f5af4649ee703bbfa974846790d332abacef03c89036babb2238c01c33780";
        proof[1] = hex"e2a03652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d3f01";

        assertFalse(SecureMerkleTrie.verifyInclusionProof(slot, value, proof, rootHash));
    }

    function test_verifyInclusionProof_fakeRoot() external {
        bytes memory slot = hex"0000000000000000000000000000000000000000000000000000000000000006"; // hash
            // = 0xf652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d3f
        bytes memory value = hex"01";
        // Leaf node (target):
        // ["0x3652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d3f","0x01"] // hash =
        // 4c020f5af4649ee703bbfa974846790d332abacef03c89036babb2238c01c337
        // Branch node (root):
        // ["0x","0x","0x","0x","0x","0x","0x","0x","0x","0x","0x","0x","0x","0x","0x","0x4c020f5af4649ee703bbfa974846790d332abacef03c89036babb2238c01c337",
        // "0x"] // hash = b21a635028fc2f2a4ba5b688497165f7096500771fd493e0695ef750c6c1845c

        bytes32 rootHash = hex"0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef";

        bytes[] memory proof = new bytes[](2);
        proof[0] =
            hex"f1808080808080808080808080808080a04c020f5af4649ee703bbfa974846790d332abacef03c89036babb2238c01c33780";
        proof[1] = hex"e2a03652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d3f01";

        vm.expectRevert("MerkleTrie: invalid root hash");
        SecureMerkleTrie.verifyInclusionProof(slot, value, proof, rootHash);
    }

    function test_verifyInclusionProof_fakeIntermediateNode() external {
        bytes memory slot = hex"0000000000000000000000000000000000000000000000000000000000000006"; // hash
            // = 0xf652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d3f
        bytes memory value = hex"01";
        // Leaf node (target):
        // ["0x3123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef","0x01"] // hash =
        // 7b074e96d2dcd6ae7a05e7e35c748e067706d28e47bfecf0c0e642f4dff48d17
        // Branch node (root):
        // ["0x","0x","0x","0x","0x","0x","0x","0x","0x","0x","0x","0x","0x","0x","0x","0x4c020f5af4649ee703bbfa974846790d332abacef03c89036babb2238c01c337",
        // "0x"] // hash = b21a635028fc2f2a4ba5b688497165f7096500771fd493e0695ef750c6c1845c

        bytes32 rootHash = hex"b21a635028fc2f2a4ba5b688497165f7096500771fd493e0695ef750c6c1845c";

        bytes[] memory proof = new bytes[](2);
        proof[0] =
            hex"f1808080808080808080808080808080a04c020f5af4649ee703bbfa974846790d332abacef03c89036babb2238c01c33780";
        proof[1] = hex"e2a03123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef01";

        vm.expectRevert("MerkleTrie: invalid large internal hash");
        SecureMerkleTrie.verifyInclusionProof(slot, value, proof, rootHash);
    }

    function test_get() external {
        bytes memory slot = hex"0000000000000000000000000000000000000000000000000000000000000006"; // hash
            // = 0xf652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d3f
        bytes memory value = hex"01";
        // Leaf node (target):
        // ["0x3652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d3f","0x01"] // hash =
        // 4c020f5af4649ee703bbfa974846790d332abacef03c89036babb2238c01c337
        // Branch node (root):
        // ["0x","0x","0x","0x","0x","0x","0x","0x","0x","0x","0x","0x","0x","0x","0x","0x4c020f5af4649ee703bbfa974846790d332abacef03c89036babb2238c01c337",
        // "0x"] // hash = b21a635028fc2f2a4ba5b688497165f7096500771fd493e0695ef750c6c1845c

        bytes32 rootHash = hex"b21a635028fc2f2a4ba5b688497165f7096500771fd493e0695ef750c6c1845c";

        bytes[] memory proof = new bytes[](2);
        proof[0] =
            hex"f1808080808080808080808080808080a04c020f5af4649ee703bbfa974846790d332abacef03c89036babb2238c01c33780";
        proof[1] = hex"e2a03652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d3f01";

        bytes memory fetchedValue = SecureMerkleTrie.get(slot, proof, rootHash);
        assertEq(fetchedValue, value);
    }
}
