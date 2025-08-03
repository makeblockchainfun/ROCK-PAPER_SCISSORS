// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RockPaperScissors {
    enum Move { None, Rock, Paper, Scissors }

    struct Player {
        address addr;
        Move[5] moves;
        uint8 moveCount;
        uint8 wins;
    }

    uint256 public entryFee = 0.001 ether;

    Player public player1;
    Player public player2;
    bool public gameStarted;
    address public winner;
    address public lastLoser;

    // Events for game actions
    event GameStarted(address player1, address player2);
    event MovePlayed(address player, uint8 move);
    event GameFinished(address winner, uint8 player1Wins, uint8 player2Wins);

    modifier onlyPlayers() {
        require(msg.sender == player1.addr || msg.sender == player2.addr, "Not a player");
        _;
    }

    function joinGame() external payable {
        require(msg.value == entryFee, "Wrong ETH amount");
        require(!gameStarted || player2.addr == address(0), "Game full");

        if (!gameStarted) {
            player1 = Player(msg.sender, [Move.None, Move.None, Move.None, Move.None, Move.None], 0, 0);
            gameStarted = true;
        } else {
            require(msg.sender != player1.addr, "Player 1 already joined");
            player2 = Player(msg.sender, [Move.None, Move.None, Move.None, Move.None, Move.None], 0, 0);
            emit GameStarted(player1.addr, player2.addr);
        }
    }

    function playMove(uint8 move) external onlyPlayers {
        require(move >= 1 && move <= 3, "Invalid move");
        require(player2.addr != address(0), "Opponent not joined");

        Player storage player = msg.sender == player1.addr ? player1 : player2;
        require(player.moveCount < 5, "No moves left");

        player.moves[player.moveCount] = Move(move);
        player.moveCount++;
        emit MovePlayed(msg.sender, move);

        if (player1.moveCount == player2.moveCount) {
            _evaluateRound(player1.moveCount - 1);
        }

        if (player1.moveCount == 5 && player2.moveCount == 5) {
            _determineWinner();
        }
    }

    function _evaluateRound(uint8 index) internal {
        Move p1 = player1.moves[index];
        Move p2 = player2.moves[index];

        if (p1 == p2) return; // Tie
        if ((p1 == Move.Rock && p2 == Move.Scissors) ||
            (p1 == Move.Scissors && p2 == Move.Paper) ||
            (p1 == Move.Paper && p2 == Move.Rock)) {
            player1.wins++;
        } else {
            player2.wins++;
        }
    }

    function _determineWinner() internal {
        uint256 prizePool = address(this).balance;
        address _winner;
        address _lastLoser;

        if (player1.wins > player2.wins) {
            _winner = player1.addr;
            _lastLoser = player2.addr;
        } else if (player2.wins > player1.wins) {
            _winner = player2.addr;
            _lastLoser = player1.addr;
        } else {
            // Tie: refund both players
            payable(player1.addr).transfer(entryFee);
            payable(player2.addr).transfer(entryFee);
            emit GameFinished(address(0), player1.wins, player2.wins);
            _resetGame();
            return;
        }

        payable(_winner).transfer(prizePool);
        winner = _winner;
        lastLoser = _lastLoser;
        emit GameFinished(_winner, player1.wins, player2.wins);
        _resetGame();
    }

    function cancelGame() external {
        require(gameStarted && player2.addr == address(0), "No active game");
        require(msg.sender == player1.addr, "Only Player 1 can cancel");
        payable(player1.addr).transfer(entryFee);
        _resetGame();
    }

    function forfeit() external onlyPlayers {
        address forfeiter = msg.sender;
        address opponent = forfeiter == player1.addr ? player2.addr : player1.addr;
        require(opponent != address(0), "No opponent");

        winner = opponent;
        lastLoser = forfeiter;
        payable(winner).transfer(2 * entryFee);
        emit GameFinished(winner, player1.wins, player2.wins);
        _resetGame();
    }

    function _resetGame() internal {
        gameStarted = false;
        player1 = Player(address(0), [Move.None, Move.None, Move.None, Move.None, Move.None], 0, 0);
        player2 = Player(address(0), [Move.None, Move.None, Move.None, Move.None, Move.None], 0, 0);
    }
}
