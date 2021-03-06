module NDCClient
  module Messages

    class OrderCreateRQ < Messages::Base

      def initialize(params = {})
        super(params)
      end

      def yield_core_query(data, xml)

        xml.Query {
          if data.hpath('Query/Passengers').present?
            xml.Passengers {
              data.hpath('Query/Passengers').each do |passenger|
                xml.Passenger((passenger.hpath('Passenger/_ObjectKey').present? ? {ObjectKey: passenger.hpath('Passenger/_ObjectKey')} : nil )) {
                  xml.PTC((passenger.hpath('Passenger/PTC/_Quantity').present? ? {Quantity: passenger.hpath('Passenger/PTC/_Quantity')} : nil )) { xml.text passenger.hpath('Passenger/PTC/__text') }
                  xml.ResidenceCode_ passenger.hpath('Passenger/ResidenceCode')
                  xml.Age {
                    xml.BirthDate_ passenger.hpath('Passenger/Age/BirthDate') if passenger.hpath('Passenger/PTC/Age/BirthDate').present?
                  }
                  xml.Gender_ passenger.hpath('Passenger/Gender')
                  xml.Name {
                    xml.Surname_ passenger.hpath('Passenger/Name/Surname')
                    xml.Given_ passenger.hpath('Passenger/Name/Given')
                    xml.Title_ passenger.hpath('Passenger/Name/Title')
                    xml.Middle_ passenger.hpath('Passenger/Name/Middle')
                  }
                  xml.ProfileID_ passenger.hpath('Passenger/ProfileID')
                  if passenger.hpath('Passenger/Contacts').present?
                    xml.Contacts {
                      passenger.hpath('Passenger/Contacts').each do |contact|
                        xml.Contact{
                          if contact.hpath('Contact/EmailContact').present?
                            xml.EmailContact {
                              xml.Address_ contact.hpath('Contact/EmailContact/Address')
                            }
                          end
                          if contact.hpath('Contact/PhoneContact').present?
                            xml.PhoneContact {
                              xml.Application_ contact.hpath('Contact/PhoneContact/Application')
                              xml.Number_ contact.hpath('Contact/PhoneContact/Number')
                            }
                          end
                          if contact.hpath('Contact/AddressContact').present?
                            xml.AddressContact {
                              xml.Application_ contact.hpath('Contact/AddressContact/Application')
                              xml.Street_ contact.hpath('Contact/AddressContact/Street')
                              xml.CityName {
                                xml.CityCode_ contact.hpath('Contact/AddressContact/CityName/CityCode')
                              }
                              xml.PostalCode contact.hpath('Contact/AddressContact/PostalCode')
                              xml.CountryCode contact.hpath('Contact/AddressContact/CountryCode')
                            }
                          end
                        }
                      end
                    }
                  end
                  xml.FQTVs {
                    xml.FQTV_ProgramCore {
                      xml.FQTV_ProgramID_ passenger.hpath('Passenger/FQTVs/FQTV_ProgramCore/FQTV_ProgramID')
                      xml.ProviderID_ passenger.hpath('Passenger/FQTVs/FQTV_ProgramCore/ProviderID')
                      xml.Account {
                        xml.Number_ passenger.hpath('Passenger/FQTVs/FQTV_ProgramCore/Account/Number')
                      }
                    }
                  }
                  xml.PassengerIDInfo {
                    xml.FOID {
                      xml.Type_ passenger.hpath('Passenger/PassengerIDInfo/FOID/Type')
                      xml.ID_ passenger.hpath('Passenger/PassengerIDInfo/FOID/ID')
                    }
                  }
                }
              end
            }
          end

          xml.OrderItems {
            xml.ShoppingResponse {
              xml.Owner_ data.hpath('Query/OrderItems/ShoppingResponse/Owner')
              xml.ResponseID_ data.hpath('Query/OrderItems/ShoppingResponse/ResponseID')
              if data.hpath('Query/OrderItems/ShoppingResponse/Offers').present?
                xml.Offers {
                  data.hpath('Query/OrderItems/ShoppingResponse/Offers').each do |offer|
                    xml.Offer {
                      xml.OfferID((offer.hpath('Offer/OfferID/_Owner').present? ? {Owner: offer.hpath('Offer/OfferID/_Owner')} : nil)) {xml.text offer.hpath('Offer/OfferID/__text')}
                      if offer.hpath('Offer/OfferItems').present?
                        xml.OfferItems {
                          offer.hpath('Offer/OfferItems').each do |offer_item|
                            xml.OfferItem {
                              xml.OfferItemID((offer_item.hpath('OfferItem/OfferItemID/_Owner').present? ? {Owner: offer_item.hpath('OfferItem/OfferItemID/_Owner')} : nil)) {xml.text offer_item.hpath('OfferItem/OfferItemID/__text')}
                              if offer_item.hpath('OfferItem/Passengers').present?
                                xml.Passengers {
                                  offer_item.hpath('OfferItem/Passengers').each do |passenger|
                                    xml.PassengerReference_ passenger.hpath('PassengerReference')
                                  end
                                }
                              end
                              if offer_item.hpath('OfferItem/AssociatedServices').present?
                                xml.AssociatedServices {
                                  offer_item.hpath('OfferItem/AssociatedServices').each do |associated_service|
                                    xml.AssociatedService {
                                      xml.ServiceID((associated_service.hpath('AssociatedService/ServiceID/_Owner').present? ? {Owner: associated_service.hpath('AssociatedService/ServiceID/_Owner')} : nil)) {xml.text associated_service.hpath('AssociatedService/ServiceID/__text')}
                                    }
                                  end
                                }
                              end
                            }
                          end
                        }
                      end
                    }
                  end
                }
              end
            }
          }

          if data.hpath('Query/Payments').present?
            xml.Payments {
              data.hpath('Query/Payments').each do |payment|
                xml.Payment {
                  xml.Method {
                    xml.PaymentCard {
                      xml.CardCode_ payment.hpath('Payment/Method/PaymentCard/CardCode')
                      xml.CardNumber_ payment.hpath('Payment/Method/PaymentCard/CardNumber')
                      xml.SeriesCode_ payment.hpath('Payment/Method/PaymentCard/SeriesCode')
                      xml.EffectiveExpireDate {
                        xml.Effective_ payment.hpath('Payment/Method/PaymentCard/EffectiveExpireDate/Effective')
                      }
                      xml.Amount((payment.hpath('Payment/Amount/_Taxable').present? ? {Taxable: payment.hpath('Payment/Amount/_Taxable')} : nil)) {xml.text payment.hpath('Payment/Amount/__text')}
                      xml.Payer {
                        xml.Name {
                          xml.Surname_ payment.hpath('Payment/Payer/Name/Surname')
                          xml.Given_ payment.hpath('Payment/Payer/Name/Given')
                        }
                      }
                      if payment.hpath('Payment/Payer/Contacts').present?
                        xml.Contacts {
                          payment.hpath('Payment/Payer/Contacts').each do |contact|
                            xml.Contact {
                              if contact.hpath('Contact/AddressContact').present?
                                xml.AddressContact {
                                  xml.Street_ contact.hpath('Contact/AddressContact/Street')
                                  xml.CityName {
                                    xml.CityCode_ contact.hpath('Contact/AddressContact/CityName/CityCode')
                                  }
                                  xml.PostalCode_ contact.hpath('Contact/AddressContact/PostalCode')
                                  xml.CountryCode_ contact.hpath('Contact/AddressContact/CountryCode')
                                }
                              end
                              if contact.hpath('Contact/EmailContact').present?
                                xml.EmailContact {
                                  xml.Address_ contact.hpath('Contact/EmailContact/Address')
                                }
                              end
                            }
                          end
                        }
                      end
                    }
                  }
                }
              end
            }
          end
        }
      end

    end

  end
end
