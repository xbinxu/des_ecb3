defmodule DesEcb3Test do
  use ExUnit.Case

  @cipher ~s{2bIw8OksByLYT/WX6bQCuxxf41EGL5ugYd3AGHdcLb8cGGLqL2/DhOPTsems/DEttww7yhenMOIspd6ebOQ3K0Q+A9JDcyCES3K8wFsPvO9dh1PF4Kye544ph8KOBDLMwTPqWPGaw1c8/N2xiRW5+SDotxuqsfRV8Ft5P32IAuHqX6g9+Vh0RMx57Bq8bbfgSrqZwm0t11Ev6cZsUcGldZGln+NdclGOi5l94aRhLmWRvsPjrL+SnSsK7SkToVdumTYYCIayUfReJPET4osPdcsFrRl+6Bk7mknogRQms7e63f755pScPpsdmZ8QUiy9gSEEMkYrFOLZgBhqXz91KMTHMl5vYsUWtMY3L4pKebjwqHkpYR5H3n2XNYM8W4Je}
  @plain "{\"uid\":\"20150619165213pHwH7XH58k\",\"payAmount\":\"1\",\"notifyTime\":1439196041,\"cpInfo\":\"18C6E4C44156375C3603C543833FB58777AC3C33\",\"memo\":null,\"orderAmount\":\"1\",\"orderAccount\":\"d13701391981@gmail.com\",\"code\":1,\"orderTime\":\"2015-08-10 16:40:38\",\"msg\":\"\",\"orderId\":\"15081016401360000001\"}"
  @key "p7l2EsADNmV92qTBuRowb8Aj"

  @cipher2 "w7QvdUtrPNRRAZSR+KOpr3C8i8hrgYQuS71doRd8Lswvd3gpgebw7YnBQeHx9G1QPuOa2BocHSSjEN9ScCM4rszu2tXDLl+j9T4TMcVArPxN4uS9o9639Dbqih4hueqMZWzxu/auU2GfwJHPG/6X3p01lacGIKmCu+ds9UB80mKnK8kIhoKOcgV5LpeGQWqf+TV/wWvUdyL4tgkoc475GyiqYjNefzls5Kjq6u5Jeaoz76hYmCxzk2e8uSCKOVIdqFmOGxpUBICDJmlEp6U3hMnkReeu3a3fyBmOW79prgXJ+IiuD/Jax/lvoT8VvPwmsmsIk/1xyBiPwADxD8rHvqzFWE45UBc0DiUWeL1Yo9FxZ3OiVPSH2qhZeb/SmUZb"

  test "encrypt && decrypt" do
    assert @plain == DesEcb3.decrypt(@key, @cipher |> Base.decode64!())
    assert @cipher == DesEcb3.encrypt(@key, @plain) |> Base.encode64()

    assert @cipher2 == DesEcb3.encrypt("62A60802746410CF73B480C1", @plain) |> Base.encode64()

    assert "QIl8EXJ3DGuI8hDR05T9/QzgaQcQ8d9XKDLVyAqj3BpMnUa/ug6b1A==" ==
             DesEcb3.encrypt("62A60802746410CF73B480C1", "NjJBNjA4MDI3NDY0MTBDRjczQjQ4MEMx")
             |> Base.encode64()

    assert "NjJBNjA4MDI3NDY0MTBDRjczQjQ4MEMx" ==
             DesEcb3.decrypt(
               "62A60802746410CF73B480C1",
               "QIl8EXJ3DGuI8hDR05T9/QzgaQcQ8d9XKDLVyAqj3BpMnUa/ug6b1A==" |> Base.decode64!()
             )
  end
end
