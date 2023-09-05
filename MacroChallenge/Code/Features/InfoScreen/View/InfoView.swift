

import UIKit

class InfoView: UIView {

    private lazy var title: UILabel = {
        let view = UILabel()
        view.text = "Disponibilidade"
        view.font = .SZFontTitle
        view.textColor = .SZColorBeige
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var textBold: UILabel = {
        let view = UILabel()
        view.text = """
        alta, média, baixa e baixíssima disponibilidade.
        """
        view.font = .SZFontTextBold
        view.textColor = .SZColorBeige
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    private lazy var text: UILabel = {
        let view = UILabel()
        view.text = """
        Sazoni apresenta a sazonalidade de frutas, verduras, legumes e pescados com base na tabela de sazonalidade disponibilizada pelo CEAGESP.


        Dentro dela existem quatro tipos de classificação:
        """
        view.numberOfLines = .max
        view.font = .SZFontText
        view.textColor = .SZColorBeige
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var iconHight: UIImageView = {
        var image = UIImageView()
        image = UIImageView(image: .SZSazonalityHeigth)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var textHight: UILabel = {
        var view = UILabel()
        view.numberOfLines = .max
        view.font = .SZFontText
        view.textColor = .SZColorBeige
        view.text = "Alta"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var iconMedium: UIImageView = {
        var image = UIImageView()
        image = UIImageView(image: .SZSazonalityMedium)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var textMedium: UILabel = {
        var view = UILabel()
        view.numberOfLines = .max
        view.font = .SZFontText
        view.textColor = .SZColorBeige
        view.text = "Média"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var iconLow: UIImageView = {
        var image = UIImageView()
        image = UIImageView(image: .SZSazonalityLow)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var textLow: UILabel = {
        var view = UILabel()
        view.numberOfLines = .max
        view.font = .SZFontText
        view.textColor = .SZColorBeige
        view.text = "Baixa"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var iconVeryLow: UIImageView = {
        var image = UIImageView()
        image = UIImageView(image: .SZSazonalityVeryLow)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var textVeryLow: UILabel = {
        var view = UILabel()
        view.numberOfLines = .max
        view.font = .SZFontText
        view.textColor = .SZColorBeige
        view.text = "Baixíssima"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViewConfiguration()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension InfoView: ViewCode {
    
    func buildViewHierarchy() {
        [self.title,
         self.text,
         self.textBold,
         self.iconHight,
         self.textHight,
         self.textMedium,
         self.iconMedium,
         self.iconLow,
         self.textLow,
         self.iconVeryLow,
         self.textVeryLow].forEach({ self.addSubview($0) })
    }
    
    func setupConstraints() {
        self.title.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: self.bounds.height * 0.08),
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                view.bottomAnchor.constraint(equalTo: text.topAnchor, constant: -32)
            ]
        }
        
        self.text.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: title.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),

            
            ]
        }
        
        self.textBold.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: text.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            ]
        }
        
        self.iconHight.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.textBold.bottomAnchor, constant: 32),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            ]
        }
        
        self.textHight.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.textBold.bottomAnchor, constant: 34),
                view.leadingAnchor.constraint(equalTo: self.iconHight.trailingAnchor, constant: 8),
            ]
        }
        
        self.iconMedium.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.iconHight.bottomAnchor, constant: 16),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            ]
        }
        
        self.textMedium.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.textHight.bottomAnchor, constant: 22),
                view.leadingAnchor.constraint(equalTo: self.iconMedium.trailingAnchor, constant: 8),
            ]
        }
        
        self.iconLow.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.iconMedium.bottomAnchor, constant: 16),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            ]
        }
        
        self.textLow.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.textMedium.bottomAnchor, constant: 22),
                view.leadingAnchor.constraint(equalTo: self.iconLow.trailingAnchor, constant: 8),
            ]
        }
        
        self.iconVeryLow.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.iconLow.bottomAnchor, constant: 16),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            ]
        }
        
        self.textVeryLow.setupConstraints { view in
            [
                view.topAnchor.constraint(equalTo: self.textLow.bottomAnchor, constant: 22),
                view.leadingAnchor.constraint(equalTo: self.iconVeryLow.trailingAnchor, constant: 8),
            ]
        }
    }
    
    func setupAdditionalConfiguration() {
        self.backgroundColor = .SZColorPrimaryColor
    }
}
