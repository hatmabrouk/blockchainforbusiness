pragma solidity 0.6.6;

contract SmartCertification {
    uint public certificate_counter;

    // Structs
    struct Certificate {
        string ipfsHash;
        uint timeOfIssue;
        address issuer;
        address recipient;
    }

    // Mappings
    mapping(string => address) issuerOfCertificate;
    mapping(address => string) issuer;
    mapping(address => string) recipient;
    mapping(string => address[]) allRecipientOfCertificate;
    mapping(uint => Certificate) certificateIdentifier;
    mapping(address => uint[]) recipientCertificates;
    mapping(address => uint[]) issuerCertificates;
    mapping(address => bool) isIssuer;
    mapping(address => bool) isRecipient;

    // Events
    event IssuerRegistered(address indexed issuer, string IPFS_hash);
    event RecipientRegistered(address indexed recipient, string IPFS_hash);
    event CertificateRegistered(address indexed issuer, string IPFS_hash);
    event CertificateIssued(uint indexed certificate, address indexed issuer, address indexed recipient);

    // Functions
    function registerIssuer(string memory IPFS_hash) public {
        require((isIssuer[msg.sender] == false), "Issuer already registered");
        issuer[msg.sender] = IPFS_hash;
        isIssuer[msg.sender] = true;
        emit IssuerRegistered(msg.sender, IPFS_hash);
    }

    function registerRecipient(string memory IPFS_hash) public {
        require(isRecipient[msg.sender] == false, "Recipient already registered");
        recipient[msg.sender] = IPFS_hash;
        isRecipient[msg.sender] = true;
        emit RecipientRegistered(msg.sender, IPFS_hash);
    }

    function registerCertificate(string memory IPFS_hash) public {
        require(isIssuer[msg.sender] == true, "Issuer not registered to register a certificate");
        issuerOfCertificate[IPFS_hash] = msg.sender;
        emit CertificateRegistered(msg.sender, IPFS_hash);
    }

    function issueCertificate(address _recipient, string memory certificate_hash) public {
        require(isIssuer[msg.sender] == true, "Issuer not registered to register a certificate");
        require(isRecipient[_recipient] == true, "Recipient not registered to be issued a certificate");
        require(issuerOfCertificate[certificate_hash] == msg.sender, "Issuer not registered to issue this certificate");
        Certificate memory cert;
        uint id = ++certificate_counter;
        cert.ipfsHash = certificate_hash;
        cert.timeOfIssue = now;
        cert.issuer = msg.sender;
        cert.recipient = _recipient;
        certificateIdentifier[id] = cert;
        recipientCertificates[_recipient].push(id);
        issuerCertificates[msg.sender].push(id);
        allRecipientOfCertificate[certificate_hash].push(_recipient);
        emit CertificateIssued(id, msg.sender, _recipient);
    }

    function getIssuerOfCertificate(string memory IPFS_hash) public view returns (address) {
        return issuerOfCertificate[IPFS_hash];
    }

    function getIssuer(address _issuer) public view returns (string memory) {
        return issuer[_issuer];
    }

    function getRecipient(address _recipient) public view returns (string memory ) {
        return recipient[_recipient];
    }

    function getRecipientCertificates(address _recipient) public view returns (uint256[] memory) {
        return recipientCertificates[_recipient];
    }

    function getIssuerCertificates(address _issuer) public view returns (uint256[] memory) {
        return issuerCertificates[_issuer];
    }

    function getCertificateIdentifier(uint _id) public view returns (string memory, uint, address, address){
        Certificate memory cert = certificateIdentifier[_id];
        return (cert.ipfsHash, cert.timeOfIssue, cert.issuer, cert.recipient);
    }

}
