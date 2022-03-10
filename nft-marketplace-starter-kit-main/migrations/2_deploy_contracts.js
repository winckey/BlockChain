const KryptoBird = artifacts.require("KryptoBird");
// 서버에 해당 sol파일(계약들)을 배포함
module.exports = function(deployer) {
    deployer.deploy(KryptoBird);
};
