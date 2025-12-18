//
//  HomeSegmentViewController.swift
//  HomeFeature
//
//  Created by 김재한 on 12/11/25.
//

import UIKit
import SnapKit

public final class HomeSegmentViewController: UIViewController {

    // MARK: - UI
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["First", "Second"])
        control.selectedSegmentIndex = 0
        return control
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    // MARK: - Child ViewControllers (stubs)
    private lazy var firstVC: UIViewController = StubContentViewController(title: "First")
    private lazy var secondVC: UIViewController = StubContentViewController(title: "Second")

    private var currentChild: UIViewController?

    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        switchToIndex(0)
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(segmentedControl)
        view.addSubview(containerView)
    }

    private func setupConstraints() {
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }

        containerView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setupActions() {
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }

    // MARK: - Actions
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        switchToIndex(sender.selectedSegmentIndex)
    }

    // MARK: - Child switching
    private func switchToIndex(_ index: Int) {
        let vc: UIViewController
        switch index {
        case 0: vc = firstVC
        case 1: vc = secondVC
        default: vc = firstVC
        }
        transition(to: vc)
    }

    private func transition(to newChild: UIViewController) {
        // Remove current child
        if let current = currentChild {
            current.willMove(toParent: nil)
            current.view.removeFromSuperview()
            current.removeFromParent()
        }

        // Add new child
        addChild(newChild)
        containerView.addSubview(newChild.view)
        newChild.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        newChild.didMove(toParent: self)
        currentChild = newChild
    }
}

// MARK: - Simple stub content VC for demonstration
private final class StubContentViewController: UIViewController {
    private let displayTitle: String

    init(title: String) {
        self.displayTitle = title
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().offset(16)
            make.trailing.lessThanOrEqualToSuperview().inset(16)
        }
        label.text = "Segment: \(displayTitle)"
    }
}
