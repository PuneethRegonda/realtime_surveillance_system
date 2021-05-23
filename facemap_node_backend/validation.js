const Joi = require('@hapi/joi');

const registerValidation = data => {
    console.log(data);
    data.isAdmin = Boolean(data.isAdmin)
    const schema = Joi.object({
        email: Joi.string().email().required(),
        username: Joi.string()
            .min(6).required(),
        password: Joi.string()
            .min(6)
            .required(),
        isAdmin: Joi.boolean()            
    });
    
    return schema.validate(data);
}

const loginValidation = data => {
    console.log(data);

    const schema = Joi.object({
        email: Joi.string().required(),
        password: Joi.string()
            .required(),
    });
    
    return schema.validate(data);
}

module.exports= {registerValidation,loginValidation}
