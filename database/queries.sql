-- FoodHub Market: MS Access queries (Access SQL)

-- qryMarketYearRevenue: total market revenue per year
SELECT
    Year([PaymentDateTime]) AS RevenueYear,
    Sum(tblPaymentAllocations.Amount) AS MarketRevenue
FROM
    tblPayments
    INNER JOIN tblPaymentAllocations ON tblPayments.PaymentID = tblPaymentAllocations.PaymentID
GROUP BY
    Year([PaymentDateTime])
ORDER BY
    Year([PaymentDateTime]);


-- qryStallYearRevenue: revenue per stall per year
SELECT
    Year([tblPayments].[PaymentDateTime]) AS RevenueYear,
    tblStalls.StallNumber,
    tblStalls.StallName,
    Sum(tblPaymentAllocations.Amount) AS StallRevenue
FROM
    tblStalls
    INNER JOIN (
        tblPayments
        INNER JOIN tblPaymentAllocations ON tblPayments.PaymentID = tblPaymentAllocations.PaymentID
    ) ON tblStalls.StallNumber = tblPaymentAllocations.StallNumber
GROUP BY
    Year([tblPayments].[PaymentDateTime]),
    tblStalls.StallNumber,
    tblStalls.StallName
ORDER BY
    Year([tblPayments].[PaymentDateTime]),
    tblStalls.StallNumber;


-- Stall share of yearly market revenue (%), built on top of the two queries above
SELECT
    qryStallYearRevenue.RevenueYear,
    qryStallYearRevenue.StallNumber,
    qryStallYearRevenue.StallName,
    qryStallYearRevenue.StallRevenue,
    Round([StallRevenue] / [MarketRevenue] * 100, 2) AS RevenuePct
FROM
    qryStallYearRevenue
    INNER JOIN qryMarketYearRevenue ON qryStallYearRevenue.RevenueYear = qryMarketYearRevenue.RevenueYear
ORDER BY
    qryStallYearRevenue.RevenueYear,
    qryStallYearRevenue.StallNumber;
