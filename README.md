Swing Reversion EA
Overview
The Swing Reversion EA is an MQL5-based Expert Advisor designed for automated trading on the MetaTrader 5 platform. It implements a swing trading strategy by identifying swing highs and lows to determine entry and exit points, with customizable parameters for profit targets and trade gaps.
Features

Identifies swing highs and lows based on a specified period.
Calculates entry prices using a fraction of the swing range.
Manages buy and sell positions with tail prices and average profit calculations.
Customizable magic number, average profit in pips, trade gap in pips, and swing fraction.

Installation

Copy the SwingReversionEA.mq5 file to the MQL5/Experts folder of your MetaTrader 5 installation.
Open MetaTrader 5 and compile the EA using the MetaEditor.
Attach the EA to a chart from the Navigator window.

Configuration

Magic Number (InpMagic): Unique identifier for the EA's trades (default: 123456).
Average Profit (InpAverageProfitPips): Profit target in pips (default: 10).
Trade Gap (InpTradeGapPips): Gap between tail price and entry price in pips (default: 5).
Swing Fraction (InpSwingFraction): Fraction of the swing range used for entry calculation (default: 0.5).

Usage

Configure the input parameters based on your trading strategy.
Apply the EA to a chart with the desired symbol and timeframe.
Monitor the trade execution and adjust parameters as needed.

License
Copyright © 2014-2025, StateSpeed Solutions. All rights reserved. See the source code for more details.
Support
For support or further information, visit https://statespeed.solutions