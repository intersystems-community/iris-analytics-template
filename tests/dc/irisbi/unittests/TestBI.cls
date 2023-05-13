Class dc.irisbi.unittests.TestBI Extends %UnitTest.TestCase
{

Method TestPivots()
{
     Do $$$AssertStatusOK(##class(dev.bi).checkPivots(),"Test Pivots")
}

/// Test dashboards in BI package
Method TestDashboards()
{
     Do $$$AssertStatusOK(##class(dev.bi).checkDashboards(),"Test Dashboards")
}

}
