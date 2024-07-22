# frozen_string_literal: true

require_relative "../../lib/tty-spinner"

spinners = TTY::Spinner::Multi.new("[:spinner] Top level spinner",
                                   manual_stop: true)

sp1 = spinners.register "[:spinner] one"
sp1.auto_spin

sleep(2)
sp1.success

sp2 = spinners.register "[:spinner] two"
sp3 = spinners.register "[:spinner] three"

sp2.auto_spin
sp3.auto_spin

sleep(1)
sp2.error
sleep(1)
sp3.success

spinners.error # requires manual stop
