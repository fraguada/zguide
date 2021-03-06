#
# Publisher for durable subscriber
#

package require zmq

zmq context context

# Subscriber tells us when it's ready here
zmq socket sync context PULL
sync bind "tcp://*:5564"

# We send updates via this socket
zmq socket publisher context PUB
publisher bind "tcp://*:5565"

# Wait for synchronization request
sync recv

# Now broadcast exactly 10 updates with pause
for {set update_nbr 0} {$update_nbr < 10} {incr update_nbr} {
    puts $update_nbr
    publisher send "Update $update_nbr"
    after 1000
}
publisher send "END"

sync close
publisher close
context term

