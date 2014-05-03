module Redis (
	rcon,
	rcmd) where

import qualified Database.Redis as RED

rcondef = RED.connect RED.defaultConnectInfo
rcon h p = RED.connect $
	RED.ConnInfo {
		RED.connectHost=h,
--		RED.connectPort=RED.connectPort RED.defaultConnectInfo,
		RED.connectPort = RED.PortNumber p,
		RED.connectAuth=RED.connectAuth RED.defaultConnectInfo,
		RED.connectMaxConnections=RED.connectMaxConnections RED.defaultConnectInfo,
		RED.connectMaxIdleTime=RED.connectMaxIdleTime RED.defaultConnectInfo
	}

rcmd r act = RED.runRedis r $ do act
