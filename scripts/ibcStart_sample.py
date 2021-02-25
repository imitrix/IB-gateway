import os
import logging
import json
import base64
from ib_insync import Stock, Future, util
from ib_insync import ibcontroller
from ib_insync import IB
from ib_insync.ibcontroller import Watchdog
import ib_insync.util as util

ibc = IBC(981, gateway=True, tradingMode='live',
    userid='edemo', password='demouser')
util.logToConsole(logging.DEBUG)
logger = logging.getLogger(name=__name__)


ibc.start()

ib = IB()
watchdog = Watchdog(
    ibc,
    ib,
    port=4001,
    connectTimeout=59,
    appStartupTime=45,
    appTimeout=59,
    retryDelay=10,
)
watchdog.start()

ib.sleep(60)



IB.run()


