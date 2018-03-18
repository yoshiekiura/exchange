pragma solidity ^0.4.11;

contract SafeMath {
  function safeMul(uint a, uint b) internal returns (uint) {
    uint c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function safeSub(uint a, uint b) internal returns (uint) {
    assert(b <= a);
    return a - b;
  }

  function safeAdd(uint a, uint b) internal returns (uint) {
    uint c = a + b;
    assert(c>=a && c>=b);
    return c;
  }
}

contract Token {
  /// @return total amount of tokens
  function totalSupply() constant returns (uint256 supply) {
    supply=supply;
  }

  /// @param _owner The address from which the balance will be retrieved
  /// @return The balance
  function balanceOf(address _owner) constant returns (uint256 balance) {
    _owner=_owner;
    balance=balance;
  }

  /// @notice send `_value` token to `_to` from `msg.sender`
  /// @param _to The address of the recipient
  /// @param _value The amount of token to be transferred
  /// @return Whether the transfer was successful or not
  function transfer(address _to, uint256 _value) returns (bool success) {
    _to=_to;
    _value=_value;
    success=success;
  }

  /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
  /// @param _from The address of the sender
  /// @param _to The address of the recipient
  /// @param _value The amount of token to be transferred
  /// @return Whether the transfer was successful or not
  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
    _from=_from;
    _to=_to;
    _value=_value;
    success=success;
  }

  /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
  /// @param _spender The address of the account able to transfer the tokens
  /// @param _value The amount of wei to be approved for transfer
  /// @return Whether the approval was successful or not
  function approve(address _spender, uint256 _value) returns (bool success) {
    _spender=_spender;
    _value=_value;
    success=success;
  }

  /// @param _owner The address of the account owning tokens
  /// @param _spender The address of the account able to transfer the tokens
  /// @return Amount of remaining tokens allowed to spent
  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
    _owner=_owner;
    _spender=_spender;
    remaining=remaining;
  }

  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);

  uint public decimals;
  string public name;
}

contract StandardToken is Token {

  function transfer(address _to, uint256 _value) returns (bool success) {
    //Default assumes totalSupply can't be over max (2^256 - 1).
    //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
    //Replace the if with this one instead.
    if(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
      //if(balances[msg.sender] >= _value && _value > 0) {
      balances[msg.sender] -= _value;
      balances[_to] += _value;
      Transfer(msg.sender, _to, _value);
      return true;
    } else {
      return false;
    }
  }

  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
    //same as above. Replace this line with the following if you want to protect against wrapping uints.
    if(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
      //if(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
      balances[_to] += _value;
      balances[_from] -= _value;
      allowed[_from][msg.sender] -= _value;
      Transfer(_from, _to, _value);
      return true;
    } else {
      return false;
    }
  }

  function balanceOf(address _owner) constant returns (uint256 balance) {
    return balances[_owner];
  }

  function approve(address _spender, uint256 _value) returns (bool success) {
    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
    return allowed[_owner][_spender];
  }

  mapping(address => uint256) balances;

  mapping (address => mapping (address => uint256)) allowed;

  uint256 public totalSupply;
}

contract ReserveToken is StandardToken, SafeMath {
  address public minter;
  function ReserveToken() {
    minter = msg.sender;
  }

  function create(address account, uint amount) {
    if(msg.sender != minter) {
      revert();
    }
    balances[account] = safeAdd(balances[account], amount);
    totalSupply = safeAdd(totalSupply, amount);
  }
  function destroy(address account, uint amount) {
    if(msg.sender != minter) {
      revert();
    }
    if(balances[account] < amount) revert();
    balances[account] = safeSub(balances[account], amount);
    totalSupply = safeSub(totalSupply, amount);
  }
}

contract ERC20Interface {
  // Get the total token supply
  uint256 public totalSupply;

  // Get the account balance of another account with address _owner
  function balanceOf(address _owner) constant returns (uint256 balance);

  // Send _value amount of tokens to address _to
  function transfer(address _to, uint256 _value) returns (bool success);

  // Send _value amount of tokens from address _from to address _to
  function transferFrom(address _from, address _to, uint256 _value) returns (bool success);

  // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
  // If this function is called again it overwrites the current allowance with _value.
  // this function is required for some DEX functionality
  function approve(address _spender, uint256 _value) returns (bool success);

  // Returns the amount which _spender is still allowed to withdraw from _owner
  function allowance(address _owner, address _spender) constant returns (uint256 remaining);

  // Triggered when tokens are transferred.
  event Transfer(address indexed _from, address indexed _to, uint256 _value);

  // Triggered whenever approve(address _spender, uint256 _value) is called.
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract ImmutableShares is ERC20Interface { 
  string public constant symbol = "CSH";
  string public constant name = "Cryptex Shares";
  uint8 public constant decimals = 0;
  // uint256 _totalSupply = 53000000;
  uint256 public totalSupply;
  uint256 public TotalDividendsPerShare;
  address public fallbackAccount = 0x0099F456e88E0BF635f6B2733e4228a2b5749675; 

  // Owner of this contract
  address public owner;

  // Balances for each account
  mapping(address => uint256) public balances;

  // Owner of account approves the transfer of an amount to another account
  mapping(address => mapping (address => uint256)) allowed;

  // dividends paid per share
  mapping (address => uint256) public dividendsPaidPerShare;
   
  // Functions with this modifier can only be executed by the owner
  modifier onlyOwner() {
    if(msg.sender != owner) {
      revert();
    }
    _;
  }
   
  // Constructor
  function ImmutableShares() {
    owner = msg.sender;
    balances[owner] = totalSupply;
    totalSupply = totalSupply;  // Update total supply
  }


  function isContract(address addr) returns (bool) {
    uint size;
    assembly { size := extcodesize(addr) }
    return size > 0;
    addr=addr;
  }

  function changeFallbackAccount(address fallbackAccount_) {
    if(msg.sender != owner) {
      revert();
    }
    fallbackAccount = fallbackAccount_;
  }

  //withdraw function
  function withdrawMyDividend() payable {
    bool IsContract = isContract(msg.sender);
    if((balances[msg.sender] > 0) && (!IsContract)) {
      uint256 AmountToSendPerShare = TotalDividendsPerShare - dividendsPaidPerShare[msg.sender];
      dividendsPaidPerShare[msg.sender] = TotalDividendsPerShare;
      if((balances[msg.sender]*AmountToSendPerShare) > 0) {
        msg.sender.transfer(balances[msg.sender]*AmountToSendPerShare);
      }
    }

    if((balances[msg.sender] > 0) && (IsContract)) {
      uint256 AmountToSendPerShareEx = TotalDividendsPerShare - dividendsPaidPerShare[msg.sender];
      dividendsPaidPerShare[msg.sender] = TotalDividendsPerShare;
      if((balances[msg.sender]*AmountToSendPerShareEx) > 0) {
        fallbackAccount.transfer(balances[msg.sender]*AmountToSendPerShareEx);
      }
    }

  }

  //pay receiver’s dividends
  function payReceiver(address ReceiverAddress) payable {
    if(balances[ReceiverAddress] > 0) {
      uint256 AmountToSendPerShare = TotalDividendsPerShare - dividendsPaidPerShare[ReceiverAddress];
      dividendsPaidPerShare[ReceiverAddress] = TotalDividendsPerShare;
      if((balances[ReceiverAddress]*AmountToSendPerShare) > 0) {
        ReceiverAddress.transfer(balances[ReceiverAddress]*AmountToSendPerShare);
      }
    }
  }
  
   
  // What is the balance of a particular account?
  function balanceOf(address _owner) constant returns (uint256 balance) {
    return balances[_owner];
  }
   
  // Transfer the balance from owner's account to another account
  function transfer(address _to, uint256 _amount) returns (bool success) {
    if(balances[msg.sender] >= _amount &&
    _amount > 0 &&
    balances[_to] + _amount > balances[_to]) {
      withdrawMyDividend();
      payReceiver(_to);

      balances[msg.sender] -= _amount;
      balances[_to] += _amount;
      Transfer(msg.sender, _to, _amount);

      dividendsPaidPerShare[_to] = TotalDividendsPerShare;

      return true;
    } else {
      return false;
    }
  }
   
  // Send _value amount of tokens from address _from to address _to
  // The transferFrom method is used for a withdraw workflow, allowing contracts to send
  // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
  // fees in sub-currencies; the command should fail unless the _from account has
  // deliberately authorized the sender of the message via some mechanism; we propose
  // these standardized APIs for approval:
  function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
    if(balances[_from] >= _amount &&
    allowed[_from][msg.sender] >= _amount &&
    _amount > 0 &&
    balances[_to] + _amount > balances[_to]) {
      withdrawMyDividend();
      payReceiver(_to);

      balances[_from] -= _amount;
      allowed[_from][msg.sender] -= _amount;
      balances[_to] += _amount;
      Transfer(_from, _to, _amount);

      dividendsPaidPerShare[_from] = TotalDividendsPerShare;     
      dividendsPaidPerShare[_to] = TotalDividendsPerShare;

      return true;
    } else {
      return false;
    }
  }
  
  // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
  // If this function is called again it overwrites the current allowance with _value.
  function approve(address _spender, uint256 _amount) returns (bool success) {
    allowed[msg.sender][_spender] = _amount;
    Approval(msg.sender, _spender, _amount);
    return true;
  }

  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
    return allowed[_owner][_spender];
  }
 }

contract AccountLevels {
  function accountLevel(address user) constant returns(uint) {
    user=user;
  }
}

contract AccountLevelsTest is AccountLevels {
  mapping (address => uint) public accountLevels;

  function setAccountLevel(address user, uint level) {
    accountLevels[user] = level;
  }

  function accountLevel(address user) constant returns(uint) {
    return accountLevels[user];
  }
}

contract Cryptex is SafeMath, ERC20Interface {
  // Define from constructor
  string public name;
  string public symbol;
  uint256 public totalSupply;
  uint8 public decimals = 0;
  address public creator;

  // Take fee in finneys
  uint feeLevel1 = 5000000000000000;
  uint feeLevel2 = 4000000000000000;
  uint feeLevel3 = 3000000000000000;
  uint feeLevel4 = 2000000000000000;
  uint feeLevel5 = 1000000000000000;

  // Variables for dividends
  uint256 public TotalDividendsPerShare;
  mapping(address => uint256) public balances;
  mapping(address => uint256) public trades;
  mapping (address => uint256) public dividendsPaidPerShare;
  mapping(address => mapping (address => uint256)) allowed;

  address public admin; //the admin address
  address feeAccount; //the account that will receive fees
  address accountLevelsAddr; //the address of the AccountLevels contract
  uint feeMake = 0;
  uint feeTake = 5;  // SAVE THIS
  uint noOfTrades = 0;  // SAVE THIS
  uint feeRebate = 0;
  mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
  mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
  mapping (address => mapping (bytes32 => uint)) public orderFills; //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
  

  uint public tradeFee;
  uint public feesPool;
  address public sharesAddress = 0xA8CDE321DDB903bfeA9b64E2c938c1BE5468bB75;
  uint public gasFee = 1000000;

  // Events
  event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
  event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
  event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
  event Deposit(address token, address user, uint amount, uint balance);
  event Withdraw(address token, address user, uint amount, uint balance);

  function Cryptex(string tokenName_, string tokenSymbol_, uint256 tokenSupply_, uint8 tokenDecimals_) {
    name = tokenName_;
    symbol = tokenSymbol_;
    totalSupply = tokenSupply_;
    decimals = tokenDecimals_;

    creator = msg.sender; // Define creator
    balances[creator] = totalSupply; // All tokens to creator
  }
 
  function () {
    revert();
  }

  // function getNumberOfTrades(address _owner) {
  //  return trades[_owner];
  // }

  function getFeeTake(address _user) constant returns (uint feeTake_) {
    noOfTrades = trades[_user];
    if(noOfTrades < 10) {
      feeTake = feeLevel1;
    } else if(noOfTrades >= 10 && noOfTrades < 20) {
      feeTake = feeLevel2;
    } else if(noOfTrades >= 20 && noOfTrades < 50) {
      feeTake = feeLevel3;
    } else if(noOfTrades >= 50 && noOfTrades < 100) {
      feeTake = feeLevel4;
    } else if(noOfTrades >= 100) {
      feeTake = feeLevel5;
    }
    return feeTake;
  }

  function transferDividendToShares() {
    if(feesPool > 5300000000000000000) {
      bool boolsent;
      feesPool -=  5300000000000000000;
      boolsent = sharesAddress.call.gas(gasFee).value(5300000000000000000)();
    }
  }

  function deposit() payable {
    tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender], msg.value);
    Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
  }

  function withdraw(uint amount) {
    if(tokens[0][msg.sender] < amount) {
      revert();
    }
    tokens[0][msg.sender] = safeSub(tokens[0][msg.sender], amount);
    if(!msg.sender.call.value(amount)()) {
      revert();
    }
    Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
  }

  function depositToken(address token, uint amount) {
    //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
    if(token==0) {
      revert();
    }
    if(!Token(token).transferFrom(msg.sender, this, amount)) {
      revert();
    }
    tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
    Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
  }

  function withdrawToken(address token, uint amount) {
    if(token==0) {
      revert();
    }
    if(tokens[token][msg.sender] < amount) {
      revert();
    }
    tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
    if(!Token(token).transfer(msg.sender, amount)) {
      revert();
    }
    Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
  }

  function balanceOfToken(address token, address user) constant returns (uint) {
    // Old balanceOf() function (see below)
    return tokens[token][user];
  }

  function balanceOf(address _owner) constant returns (uint256 balance) {
    // New balanceOf() function - ERC20 Compilant
    return balances[_owner];
  }

  function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) {
    bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
    orders[msg.sender][hash] = true;
    Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);
  }

  function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) {
    // amount is in amountGet terms
    bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
    if(!(
    (orders[user][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
    block.number <= expires &&
    safeAdd(orderFills[user][hash], amount) <= amountGet
    )) {
      revert();
    }
    tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
    orderFills[user][hash] = safeAdd(orderFills[user][hash], amount);
    Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);
  }

  function tradeBalances (address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {
    // uint feeMakeXfer = safeMul(amount, feeMake) / (1 ether);
    // uint feeTakeXfer = safeMul(amount, feeTake) / (1 ether);
    // uint feeRebateXfer = 0;

    uint feeTakeX = getFeeTake(user);

    if(tokenGet == 0x0000000000000000000000000000000000000) {
      // buying token for ether - add fee
      // Taker - tokens[tokenGet][msg.sender]
      // Maker - tokens[tokenGet][user]

      if(safeAdd(tokens[tokenGet][msg.sender], feeTakeX) >= amount) {
        // enough to pay fee
      } else {
        // pay fee, then make trade
        // deducting fee from all ETH available
        amount = safeSub(amount, feeTakeX);
      }

      tokens[tokenGet][msg.sender] = safeSub(tokens[tokenGet][msg.sender], safeAdd(amount, feeTakeX));

      tokens[tokenGet][user] = safeAdd(tokens[tokenGet][user], amount);

      feesPool = safeAdd(feesPool, feeTakeX);

      tokens[tokenGive][user] = safeSub(tokens[tokenGive][user], safeMul(amountGive, amount) / amountGet);
      tokens[tokenGive][msg.sender] = safeAdd(tokens[tokenGive][msg.sender], safeMul(amountGive, amount) / amountGet);
    } else {
      feesPool = safeAdd(feesPool, feeTakeX);
    }

    trades[user] += 1;

    // tokens[tokenGet][msg.sender] = safeSub(tokens[tokenGet][msg.sender], safeAdd(amount, feeTakeXfer));
    // tokens[tokenGet][user] = safeAdd(tokens[tokenGet][user], safeSub(safeAdd(amount, feeRebateXfer), feeMakeXfer));
    // tokens[tokenGet][feeAccount] = safeAdd(tokens[tokenGet][feeAccount], safeSub(safeAdd(feeMakeXfer, feeTakeXfer), feeRebateXfer));
    // tokens[tokenGive][user] = safeSub(tokens[tokenGive][user], safeMul(amountGive, amount) / amountGet);
    // tokens[tokenGive][msg.sender] = safeAdd(tokens[tokenGive][msg.sender], safeMul(amountGive, amount) / amountGet);
  }

  function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) constant returns(bool) {
    if(!(
    tokens[tokenGet][sender] >= amount &&
    availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount
    )) {
      return false;
    }
    return true;
  }

  function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {
    bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
    if(!(
    (orders[user][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
    block.number <= expires
    )) {
      return 0;
    }
    uint available1 = safeSub(amountGet, orderFills[user][hash]);
    uint available2 = safeMul(tokens[tokenGive][user], amountGet) / amountGive;
    if(available1<available2) {
      return available1;
    } 
    return available2;
  }

  function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {
    tokenGet=tokenGet;
    amountGet=amountGet;
    tokenGive=tokenGive;
    amountGive=amountGive;
    expires=expires;
    nonce=nonce;
    user=user;
    v=v;
    r=r;
    s=s;
    bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
    return orderFills[user][hash];
  }

  function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) {
    bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
    if(!(orders[msg.sender][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == msg.sender)) {
      revert();
    }
    orderFills[msg.sender][hash] = amountGet;
    Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
  }
  // Transfer the balance from owner's account to another account
  function transfer(address _to, uint256 _amount) returns (bool success) {
    if(balances[msg.sender] >= _amount &&
    _amount > 0 &&
    balances[_to] + _amount > balances[_to]) {
      balances[msg.sender] -= _amount;
      balances[_to] += _amount;
      Transfer(msg.sender, _to, _amount);

      dividendsPaidPerShare[_to] = TotalDividendsPerShare;

      return true;
    } else {
      return false;
    }
  }
   
  // Send _value amount of tokens from address _from to address _to
  // The transferFrom method is used for a withdraw workflow, allowing contracts to send
  // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
  // fees in sub-currencies; the command should fail unless the _from account has
  // deliberately authorized the sender of the message via some mechanism; we propose
  // these standardized APIs for approval:
  function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
    if(balances[_from] >= _amount &&
    allowed[_from][msg.sender] >= _amount &&
    _amount > 0 &&
    balances[_to] + _amount > balances[_to]) {

      balances[_from] -= _amount;
      allowed[_from][msg.sender] -= _amount;
      balances[_to] += _amount;
      Transfer(_from, _to, _amount);

      dividendsPaidPerShare[_from] = TotalDividendsPerShare;     
      dividendsPaidPerShare[_to] = TotalDividendsPerShare;

      return true;
    } else {
      return false;
    }
  }
  
  // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
  // If this function is called again it overwrites the current allowance with _value.
  function approve(address _spender, uint256 _amount) returns (bool success) {
    allowed[msg.sender][_spender] = _amount;
    Approval(msg.sender, _spender, _amount);
    return true;
  }

  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
    return allowed[_owner][_spender];
  }
}