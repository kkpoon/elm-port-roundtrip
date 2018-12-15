port module Ports exposing (ping, pong)


port ping : String -> Cmd msg


port pong : (String -> msg) -> Sub msg
