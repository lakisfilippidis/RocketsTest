//
//  RocketEditViewController.swift
//  TechTest
//
//  Created by Lakis Filippidis on 13/06/24.
//

import UIKit
import RxSwift
import RxCocoa

class RocketEditViewController: UIViewController {
    var viewModel: RocketViewModel
    var coordinator: RocketsCoordinator?
    private var disposeBag = DisposeBag()

    private var nameTextField = UITextField()
    private var typeTextField = UITextField()
    private var descriptionTextView = UITextView()

    init(viewModel: RocketViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    private func setupUI() {
        nameTextField.borderStyle = .roundedRect
        nameTextField.translatesAutoresizingMaskIntoConstraints = false

        typeTextField.borderStyle = .roundedRect
        typeTextField.translatesAutoresizingMaskIntoConstraints = false

        descriptionTextView.layer.borderWidth = 0.3
        descriptionTextView.layer.cornerRadius = 5.0
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.font = UIFont.systemFont(ofSize: 14.0)

        do {
            nameTextField.text = try viewModel.name.value()
            typeTextField.text = try viewModel.type.value()
            descriptionTextView.text = try viewModel.description.value()
        } catch {
            print("Error transforming view models text value: \(error)")
        }

        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(nameTextField)
        view.addSubview(typeTextField)
        view.addSubview(descriptionTextView)
        view.addSubview(saveButton)

        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            typeTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            typeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            typeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            descriptionTextView.topAnchor.constraint(equalTo: typeTextField.bottomAnchor, constant: 20),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 200),

            saveButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func saveButtonTapped() {
        if let newName = nameTextField.text {
            viewModel.name.onNext(newName)
        }
        if let newType = typeTextField.text {
            viewModel.type.onNext(newType)
        }
        if let newDescription = descriptionTextView.text {
            viewModel.description.onNext(newDescription)
        }
        viewModel.saveChanges()
        navigationController?.popViewController(animated: true)
    }
}

