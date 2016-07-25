/* jshint node: true */
'use strict';

module.exports = {
    up: function(queryInterface, Sequelize) {
        return queryInterface.createTable('Sessions', {
            sid: {
                primaryKey: true,
                type: Sequelize.STRING(32)
            },
            expires: {
                type: Sequelize.DATE
            },
            createdAt: {
                type: Sequelize.DATE,
                defaultValue: Sequelize.NOW
            },
            updatedAt: {
                type: Sequelize.DATE,
                defaultValue: Sequelize.NOW
            },
            data: {
                type: Sequelize.TEXT
            }
        });
    },
    down: function(queryInterface, Sequelize) {
        return queryInterface.dropTable('Sessions');
    }
};