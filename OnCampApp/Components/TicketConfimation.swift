import SwiftUI
import Stripe

public struct TicketConfirmationFlow: View {
    let event: Event
    let addons: Set<String>
    let totalPrice: Double
    @State private var currentStep = 0
    @Environment(\.presentationMode) var presentationMode
    @State private var paymentIntent: STPPaymentIntent?
    @State private var isLoading = false

    public var body: some View {
        NavigationView {
            VStack {
                switch currentStep {
                case 0:
                    TicketRecapView(event: event, addons: addons, totalPrice: totalPrice, onNext: { currentStep += 1 })
                case 1:
                    StripePaymentView(totalPrice: totalPrice, onPaymentSuccess: {
                        currentStep += 1
                    }, onPaymentFailure: { error in
                        // Handle payment failure
                        print("Payment failed: \(error.localizedDescription)")
                    })
                case 2:
                    PurchaseCompletedView(onDone: { presentationMode.wrappedValue.dismiss() })
                default:
                    EmptyView()
                }
            }
            .navigationBarTitle("Ticket Confirmation", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

public struct TicketRecapView: View {
    let event: Event
    let addons: Set<String>
    let totalPrice: Double
    let onNext: () -> Void

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Ticket Summary")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color("LTBL"))

                VStack(alignment: .leading, spacing: 10) {
                    Text("Event: \(event.title)")
                    Text("Date: September 15, 2023")
                    Text("Time: 8:00 PM")
                }
                .foregroundColor(Color("LTBL"))

                if !addons.isEmpty {
                    Text("Add-ons:")
                        .font(.headline)
                        .foregroundColor(Color("LTBL"))
                    ForEach(addons.sorted(), id: \.self) { addon in
                        Text("• \(addon)")
                            .foregroundColor(Color("LTBL"))
                    }
                }

                Text("Total Price: $\(String(format: "%.2f", totalPrice))")
                    .font(.headline)
                    .foregroundColor(Color("LTBL"))

                Spacer()

                Button(action: onNext) {
                    Text("Proceed to Payment")
                        .fontWeight(.semibold)
                        .foregroundColor(Color("LTBLALT"))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("LTBL"))
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .background(Color("LTBLALT"))
    }
}

public struct StripePaymentView: View {
    let totalPrice: Double
    let onPaymentSuccess: () -> Void
    let onPaymentFailure: (Error) -> Void
    @State private var paymentMethodParams: STPPaymentMethodParams?
    @State private var isLoading = false
    private var authenticationContext = PaymentAuthenticationContext()

    public init(totalPrice: Double, onPaymentSuccess: @escaping () -> Void, onPaymentFailure: @escaping (Error) -> Void) {
        self.totalPrice = totalPrice
        self.onPaymentSuccess = onPaymentSuccess
        self.onPaymentFailure = onPaymentFailure
    }

    public var body: some View {
        VStack(spacing: 20) {
            Text("Enter Payment Details")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color("LTBL"))

            StripePaymentCardTextField(paymentMethodParams: $paymentMethodParams)
                .frame(height: 50) // Adjust height if needed

            Button(action: processPayment) {
                Text(isLoading ? "Processing..." : "Pay $\(String(format: "%.2f", totalPrice))")
                    .fontWeight(.semibold)
                    .foregroundColor(Color("LTBLALT"))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("LTBL"))
                    .cornerRadius(10)
            }
            .disabled(paymentMethodParams == nil || isLoading)
        }
        .padding()
        .background(Color("LTBLALT"))
    }

    private func processPayment() {
        guard let paymentMethodParams = paymentMethodParams else { return }
        isLoading = true

        // In a real app, you would create a PaymentIntent on your server and return the client secret
        let clientSecret = "your_payment_intent_client_secret"

        let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
        paymentIntentParams.paymentMethodParams = paymentMethodParams

        STPPaymentHandler.shared().confirmPayment(paymentIntentParams, with: authenticationContext) { status, paymentIntent, error in
            DispatchQueue.main.async {
                isLoading = false
                switch status {
                case .succeeded:
                    onPaymentSuccess()
                case .failed:
                    if let error = error {
                        onPaymentFailure(error)
                    }
                case .canceled:
                    print("Payment canceled")
                @unknown default:
                    break
                }
            }
        }
    }
}

class PaymentAuthenticationContext: NSObject, STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        // Return the current view controller
        return UIApplication.shared.windows.first!.rootViewController!
    }
}

public struct StripePaymentCardTextField: UIViewRepresentable {
    @Binding var paymentMethodParams: STPPaymentMethodParams?

    public func makeUIView(context: Context) -> STPPaymentCardTextField {
        let paymentCardTextField = STPPaymentCardTextField()
        paymentCardTextField.delegate = context.coordinator
        return paymentCardTextField
    }

    public func updateUIView(_ uiView: STPPaymentCardTextField, context: Context) {}

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public class Coordinator: NSObject, STPPaymentCardTextFieldDelegate {
        var parent: StripePaymentCardTextField

        init(_ parent: StripePaymentCardTextField) {
            self.parent = parent
        }

        public func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
            let cardParams = textField.cardParams
            parent.paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: nil, metadata: nil)
        }
    }
}

public struct PurchaseCompletedView: View {
    let onDone: () -> Void

    public var body: some View {
        ZStack {
            Color("LTBL")
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)

                Text("You're all set!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("Your ticket receipt has been sent to your email.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)

                Button(action: onDone) {
                    Text("Done")
                        .fontWeight(.semibold)
                        .foregroundColor(Color("LTBL"))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
            }
            .padding()
        }
    }
}
