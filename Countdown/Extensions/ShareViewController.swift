//  Created by Gagandeep Singh on 6/10/20.

import SwiftUI

struct ShareView: UIViewControllerRepresentable {
    let countdown: Countdown

    func makeUIViewController(context: Context) -> some UIViewController {
        ShareViewController(countdown)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

final class ShareViewController: UIViewController {
    let countdown: Countdown
    let host: UIHostingController<CardWrapper>

    private let hiddenContainer: UIView  = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 480).isActive = true
        view.heightAnchor.constraint(equalToConstant: 480).isActive = true
        view.isHidden = true
        return view
    }()

    private let container: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()

    private let bgImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()

    let blur: UIVisualEffectView = {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
        blur.translatesAutoresizingMaskIntoConstraints = false
        return blur
    }()

    init(_ countdown: Countdown) {
        self.countdown = countdown
        let card = CardFrontView(countdown: countdown, style: .shareable, addWatermark: !PurchaseManager.shared.hasPremium)
        host = UIHostingController(rootView: CardWrapper(card: card))
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bgImageView.image = countdown.image
        view.addSubview(hiddenContainer)
        view.addSubview(bgImageView)
        view.addSubview(container)
        bgImageView.addSubview(blur)

        NSLayoutConstraint.activate([
            bgImageView.topAnchor.constraint(equalTo: view.topAnchor),
            bgImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bgImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            container.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.widthAnchor.constraint(greaterThanOrEqualToConstant: 400),
            container.widthAnchor.constraint(lessThanOrEqualToConstant: 600),
            container.widthAnchor.constraint(equalTo: container.heightAnchor),

            blur.topAnchor.constraint(equalTo: bgImageView.topAnchor),
            blur.leadingAnchor.constraint(equalTo: bgImageView.leadingAnchor),
            blur.trailingAnchor.constraint(equalTo: bgImageView.trailingAnchor),
            blur.bottomAnchor.constraint(equalTo: bgImageView.bottomAnchor),
        ])

        addChild(host)
        host.willMove(toParent: self)
        if let view = host.view {
            hiddenContainer.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: hiddenContainer.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: hiddenContainer.trailingAnchor),
                view.topAnchor.constraint(equalTo: hiddenContainer.topAnchor),
                view.bottomAnchor.constraint(equalTo: hiddenContainer.bottomAnchor)
            ])
        }
        host.didMove(toParent: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let image = hiddenContainer.subviews.first?.asImage(rect: hiddenContainer.bounds) {
            container.image = image
            let ac = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            ac.popoverPresentationController?.sourceView = container
            ac.popoverPresentationController?.sourceRect = container.bounds
            ac.completionWithItemsHandler = { _, success, _, _ in
                self.dismiss(animated: true, completion: nil)
            }
            present(ac, animated: true)
        }
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct CardWrapper: View {
    let card: CardFrontView

    var body: some View {
        card
            .contentShape(Rectangle())
            .aspectRatio(1, contentMode: .fit)
    }
}
