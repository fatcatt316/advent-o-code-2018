Code.load_file("box_scanner.ex", __DIR__)

ExUnit.start
ExUnit.configure exclude: :pending, trace: true

defmodule BoxScannerTest do
  use ExUnit.Case

  test "test_input checksum" do
    assert BoxScanner.checksum("test_input.txt") == 12
  end

  test "for_real_input checksum" do
    assert BoxScanner.checksum("for_real_input.txt") == 4920
  end
end
