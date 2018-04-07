pragma solidity ^0.4.4;

contract SimpleAuction{
    
    //拍卖的参数
    address ublic beneficiary;
    uint public auctionStart;
    uint public biddingTime;

    //当前拍卖状态
    address public highestBidder;
    uint public highestBid;

    //在结束时设置为true来拒绝任何改变
    bool ended;

    //改变时会出发的event
    event HighestBidBidIncreased(address bidder,uint amount);
    event AuctionEnded(address winner,uint amount);

    //创建一个合约，传入竞拍时间和竞拍者，solidity中now表示当前时间
    function SimpleAuction(uint _biddingTime, address _beneficiary){
        beneficiary = _beneficiary;
        auctionStart  = now;
        biddingTime = _biddingTime;
    }

    //保证金随交易事务发送，只有竞拍失败的时候才会退回
    fuction bid(){
        if(now > auctionStart + biddingTime)
            throw;
        if(msg.value <= highestBid)
            throw;
        if(highestBidder != 0)
            highestBidder.send(highestBid);
        highestBidder = msg.sender;
        highestBid = msg.value;
        HighestBidBidIncreased(msg.sender,msg.value);
    }

    ///拍卖结束后发送最高的竞价到拍卖人
    function auctionEnd(){
        if (now <= auctionStart + biddingTime)
            throw;
            //拍卖还没结束
        if(ended)
            throw;
        AuctionEnded(highestBidder,highestBid);

        //发送合约拥有的钱，因为一些保证金可能退回失败了
        beneficiary.send(this.banlance);
        ended = true;
    }

    function (){
        //这个函数将会在发送到合约的交易事务包含无效数据
        //或者无数据时执行，这里撤销所有的发送
        //所以没有人会在使用合约时因为意外而丢钱
        throw;
    }
}
